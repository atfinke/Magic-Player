//
//  AudioManager.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/25/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import AVFoundation
import MediaPlayer
import Cocoa

class AudioManager: NSObject {
    
    // MARK: - Types -
    
    enum RefreshError {
        case network
        case feedFormat
    }
    
    enum Result {
        case success
        case error(RefreshError)
    }
    
    enum PlaybackState {
        case downloading(item: AudioFeedItem, percent: String)
        case playing(item: AudioFeedItem, name: String)
        case paused(item: AudioFeedItem, name: String)
        case finished
    }

    // MARK: - Properties -
    
    private(set) var feed: AudioFeed?
    private let downloadedItems = DownloadedAudioItems.loadFromDisk()
    
    private var isInRepeatRandomMode = false {
        didSet {
            if case .finished = playbackState {
                playRandomItem()
            }
        }
    }
    
    var playbackState: PlaybackState = .finished {
        didSet {
            onPlaybackUpdate?(playbackState)
            
            let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
            switch playbackState {
            case .downloading:
                nowPlayingInfoCenter.playbackState = .stopped
            case .playing(_, let name):
                nowPlayingInfoCenter.playbackState = .playing
                
                var nowPlayingInfo = [String: Any]()
                nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = NSNumber(value: MPNowPlayingInfoMediaType.audio.rawValue)
                nowPlayingInfo[MPMediaItemPropertyTitle] = name
                nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            case .paused:
                nowPlayingInfoCenter.playbackState = .paused
            case .finished:
                nowPlayingInfoCenter.playbackState = .stopped
                nowPlayingInfoCenter.nowPlayingInfo = nil
                if isInRepeatRandomMode {
                    playRandomItem()
                }
            }
        }
    }
    
    var onPlaybackUpdate: ((PlaybackState) -> Void)?
    let player = AVPlayer()

    // MARK: - Initalization -
    
    override init() {
        super.init()
        
        let center = MPRemoteCommandCenter.shared()
        center.togglePlayPauseCommand.isEnabled = true
        center.togglePlayPauseCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.togglePlayback()
            return .success
        }
        
        center.previousTrackCommand.isEnabled = true
        center.previousTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.restart()
            return .success
        }
        
        center.nextTrackCommand.isEnabled = true
        center.nextTrackCommand.addTarget { _ -> MPRemoteCommandHandlerStatus in
            self.next()
            return .success
        }
    }
    
    // MARK: - Feed -
    
    func refresh(completion: @escaping (Result) -> Void) {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: MagicURL.feed) { data, _, _ in
            guard let data = data else {
                completion(.error(.network))
                return
            }
            
            guard let feed = try? JSONDecoder().decode(AudioFeed.self, from: data) else {
                completion(.error(.feedFormat))
                return
            }
            
            self.feed = feed
            completion(.success)
        }
        task.resume()
    }
    
    // MARK: - Playback -
    
    func play(item: AudioFeedItem) {
        if let fileURL = downloadedItems.fileURL(for: item) {
            play(fileURL: fileURL, item: item)
            return
        }
        
        playbackState = .downloading(item: item, percent: "0%")
        
        AudioDownloader.download(item: item, onPercentUpdate: { percent in
            self.playbackState = .downloading(item: item, percent: percent)
        }, completion: { result in
            switch result {
            case .completed(let item, let fileURL):
                self.play(fileURL: fileURL, item: item)
                self.downloadedItems.downloaded(item: item, to: fileURL)
            case .error(let error):
                fatalError(String(describing: error))
            }
        })
    }
    
    private func play(fileURL: URL, item: AudioFeedItem) {
        let playerItem = AVPlayerItem(url: fileURL)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: nil) { _ in
            self.playbackState = .finished
        }
        
        func found(locationName: String) {
            playbackState = .playing(item: item, name: locationName + ": " + item.name)
        }
        
        // Ugg just terrible
        for resort in feed?.resorts ?? [] {
            for park in resort.parks {
                for land in park.lands {
                    for location in land.locations {
                        if location.items.contains(item) {
                            found(locationName: location.name)
                            return
                        }
                    }
                    if let items = land.items, items.contains(item) {
                        found(locationName: land.name)
                        return
                    }
                }
            }
            for other in resort.other {
                if other.items.contains(item) {
                    found(locationName: other.name)
                    return
                }
            }
        }
        found(locationName: "Unknown")
    }
    
    private func playRandomItem() {
        var items = [AudioFeedItem]()
        for resort in feed?.resorts ?? [] {
            let lands = resort.parks.map({ $0.lands }).flatMap({ $0 })
            let landItems = lands.map({ $0.items }).compactMap({ $0 }).flatMap({ $0 })
            items.append(contentsOf: landItems)
            
            let locations = lands.map({ $0.locations }).flatMap({ $0 }) + resort.other
            let locationItems = locations.map({ $0.items }).flatMap({ $0 })
            items.append(contentsOf: locationItems)
        }
        guard let item = items.randomElement() else { return }
        play(item: item)
    }
    
    // MARK: - Commands -
    
    func togglePlayback() {
        if case let PlaybackState.playing(item, name) = self.playbackState {
            self.player.pause()
            self.playbackState = .paused(item: item, name: name)
        } else if case let PlaybackState.paused(item, name) = self.playbackState {
            self.player.play()
            self.playbackState = .playing(item: item, name: name)
        }
    }

    func restart() {
        player.seek(to: .zero)
    }
    
    func next() {
        player.pause()
        playbackState = .finished
    }
    
    func toggleRepeatRandomMode() {
        isInRepeatRandomMode.toggle()
    }
    
}
