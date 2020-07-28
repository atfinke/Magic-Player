//
//  ViewController.swift
//  MapTest
//
//  Created by Andrew Finke on 7/23/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Cocoa
import MapKit
import SwiftUI
import AVKit

class ViewController: NSViewController, NSWindowDelegate, MKMapViewDelegate {
    
    // MARK: - Properties -
    
    private var tileRenderer: MKTileOverlayRenderer?
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.mapType = .mutedStandard
        view.pointOfInterestFilter = .excludingAll
        
        let range = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 200, maxCenterCoordinateDistance: 22000)
        view.setCameraZoomRange(range, animated: false)
        
        return view
    }()
    
    
    private let audioManager = AudioManager()
    private let routePickerView = AVRoutePickerView()
    
    private var activeAudioItem: AudioFeedItem?
    private var activeResort: AudioFeedResort? {
        didSet {
            guard let resort = activeResort else { fatalError() }
            
            let overlay = MagicTileOverlay(resort: resort)
            overlay.tileSize = CGSize(width: 256, height: 256)
            overlay.maximumZ = 20
            overlay.minimumZ = 14
            overlay.canReplaceMapContent = true
            tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
            
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(overlay)
            
            mapView.region = MKCoordinateRegion(
                center: resort.coordinate.cl,
                span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08))
        }
    }
    
    // MARK: - View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routePickerView.player = audioManager.player
        audioManager.refresh(completion: refeshed(result:))
        
        view.addSubview(mapView)
        view.addSubview(routePickerView)
        
        audioManager.onPlaybackUpdate = { state in
            DispatchQueue.main.async {
                switch state {
                case .downloading(let item, let percent):
                    self.activeAudioItem = item
                    if percent ==  "100%" {
                        self.view.window?.title = "Processing Download"
                    } else {
                        self.view.window?.title = "Downloading (\(percent))"
                    }
                case .playing(let item, let name):
                    self.activeAudioItem = item
                    self.view.window?.title = "Playing: " + name
                case .paused(_, let name):
                    self.view.window?.title = "Paused: " + name
                case .finished:
                    self.view.window?.title = ""
                }
            }
        }
        
        guard let fileMenu = NSApplication.shared.mainMenu?.item(withTitle: "File")?.submenu else { fatalError() }
        
        let browserItem = NSMenuItem(title: "Open Now Playing in Browser", action: #selector(openInBrowser), keyEquivalent: "")
        let cacheItem = NSMenuItem(title: "Open Cache Directory", action: #selector(openCacheDirectory), keyEquivalent: "")
        let randomItem = NSMenuItem(title: "Toggle Repeat Random", action: #selector(toggleRepeatRandomMode), keyEquivalent: "r")
        randomItem.keyEquivalentModifierMask = []
        
        fileMenu.insertItem(browserItem, at: 0)
        fileMenu.insertItem(cacheItem, at: 1)
        fileMenu.insertItem(NSMenuItem.separator(), at: 2)
        fileMenu.insertItem(randomItem, at: 3)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.delegate = self
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        mapView.frame = view.bounds
        
        let size: CGFloat = 40
        let padding: CGFloat = 10
        routePickerView.frame = NSRect(x: view.frame.width - size - padding, y:  view.frame.height - size - padding, width: size, height: size)
    }
    
    // MARK: - NSWindowDelegate -
    
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.hide(self)
    }
    
    // MARK: - AudioManager -
    
    func refeshed(result: AudioManager.Result) {
        switch result {
        case .success:
            DispatchQueue.main.async {
                self.activeResort = self.audioManager.feed?.resorts.first
                self.updateAnnotations()
            }
        case .error(let error):
            fatalError(String(describing: error))
        }
    }
    
    func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for resort in audioManager.feed?.resorts ?? [] {
            for park in resort.parks {
                for land in park.lands {
                    for location in land.locations {
                        let annotation = AudioFeedAnnotation(title: location.name, coordinate: location.coordinate, items: location.items)
                        mapView.addAnnotation(annotation)
                    }
                    
                    if let items = land.items {
                        let annotation = AudioFeedAnnotation(title: land.name, coordinate: land.coordinate, items: items)
                        mapView.addAnnotation(annotation)
                    }
                }
            }
            
            for other in resort.other {
                let annotation = AudioFeedAnnotation(title: other.name, coordinate: other.coordinate, items: other.items)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: - MKMapViewDelegate -
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let audioFeedAnnotation = annotation as? AudioFeedAnnotation, let name = audioFeedAnnotation.title  else {
            fatalError()
        }
        
        let annotationView = MagicAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let widthCalculatingTextView = NSTextView()
        widthCalculatingTextView.alignment = .left
        widthCalculatingTextView.string = name
        widthCalculatingTextView.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        guard let layoutManager = widthCalculatingTextView.layoutManager,
              let container = widthCalculatingTextView.textContainer else { fatalError() }
        layoutManager.ensureLayout(for: container)
        let width = layoutManager.usedRect(for: container).width
        
        let annotation = MapCalloutContentView(items: audioFeedAnnotation.items, onClick: { item in
            self.audioManager.play(item: item)
            self.mapView.deselectAnnotation(annotation, animated: true)
        })
        let hostingView = NSHostingView(rootView: annotation)
        hostingView.frame = NSRect(x: 0, y: 0, width: Int(width), height: 40 *  audioFeedAnnotation.items.count)
        
        annotationView.detailCalloutAccessoryView = hostingView
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let renderer = tileRenderer else { fatalError() }
        return renderer
    }
    
    // MARK: - Menu Items -
    
    @objc func openInBrowser() {
        guard let url = activeAudioItem?.url else { return }
        NSWorkspace.shared.open(url)
    }
    
    @objc func openCacheDirectory() {
        NSWorkspace.shared.open(MagicURL.applicationSupportDirectory)
    }
    
    @objc func toggleRepeatRandomMode() {
        audioManager.toggleRepeatRandomMode()
    }
    
}
