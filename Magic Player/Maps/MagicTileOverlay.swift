//
//  MagicTileOverlay.swift
//  MapTest
//
//  Created by Andrew Finke on 7/24/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import MapKit
import os.log

class MagicTileOverlay: MKTileOverlay {
    
    // MARK: - Properties -
    
    private let resort: AudioFeedResort
    private let cache = NSCache<NSURL, NSData>()
    private let imageDiskQueue = DispatchQueue(label: "com.andrewfinke.Magic.images.disk", qos: .background)
    
    init(resort: AudioFeedResort) {
        self.resort = resort
        super.init(urlTemplate: nil)
    }
    
    // MARK: - MKTileOverlay -
    
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        return resort.mapURL(for: path.z, x: path.x, y: path.y)
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        let tilePathURL = url(forTilePath: path)
        if let cachedData = cache.object(forKey: tilePathURL as NSURL) {
            os_log("%{public}s: using cache", log: .mapTile, type: .info, loggingName(for: path))
            result(cachedData as Data, nil)
            return
        } else if let data = loadImageDataFromDisk(for: path)  {
            os_log("%{public}s: using disk", log: .mapTile, type: .info, loggingName(for: path))
            cache.setObject(data as NSData, forKey: tilePathURL as NSURL)
            result(data, nil)
            return
        }
        
        os_log("%{public}s: using network", log: .mapTile, type: .info, loggingName(for: path))
        
        func save(data: Data) {
            cache.setObject(data as NSData, forKey: tilePathURL as NSURL)
            saveImageDataToDisk(data: data, for: path)
        }
        
        let task = URLSession.shared.dataTask(with: tilePathURL) { data, _, _ in
            guard let data = data, let image = NSImage(data: data) else {
                os_log("%{public}s: network error", log: .mapTile, type: .error, self.loggingName(for: path))
                result(nil, nil)
                return
            }
            
            if image.size == self.tileSize {
                os_log("%{public}s: network image correct size", log: .mapTile, type: .info, self.loggingName(for: path))
                save(data: data)
                result(data, nil)
                return
            } else {
                os_log("%{public}s: network image needs resize", log: .mapTile, type: .info, self.loggingName(for: path))
            }
            
            let resizedData = self.resize(image: image)
            save(data: resizedData)
            result(resizedData, nil)
        }
        task.resume()
    }
    
    // MARK: - Disk -
    
    private func fileURL(for path: MKTileOverlayPath) -> URL {
        return MagicURL.mapDirectory.appendingPathComponent("\(path.z).\(path.x).\(path.y)")
    }
    
    private func loadImageDataFromDisk(for path: MKTileOverlayPath) -> Data? {
        guard let data = try? Data(contentsOf: fileURL(for: path)) else {
            return nil
        }
        return data
    }
    
    private func saveImageDataToDisk(data: Data, for path: MKTileOverlayPath) {
        imageDiskQueue.async {
            try? data.write(to: self.fileURL(for: path))
        }
    }
    
    // MARK: - Helpers -
    
    private func resize(image: NSImage) -> Data {
        guard let bitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(tileSize.width),
            pixelsHigh: Int(tileSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0) else {
                fatalError()
        }
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
        image.draw(in: NSRect(origin: .zero, size: tileSize),
                   from: .zero,
                   operation: .copy,
                   fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        
        guard let resizedData = bitmapRep
            .representation(
                using: .jpeg,
                properties: [.compressionFactor: 0.4]) else { fatalError() }
        return resizedData
    }
    
    private func loggingName(for path: MKTileOverlayPath) -> String {
        return "\(path.z).\(path.x).\(path.y)"
    }
    
   
}
