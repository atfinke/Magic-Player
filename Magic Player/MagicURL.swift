//
//  MagicURL.swift
//  MapTest
//
//  Created by Andrew Finke on 7/24/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

struct MagicURL {
    static var applicationSupportDirectory: URL {
        guard let url = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("Magic Player") else {
                fatalError()
        }
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        return url
    }
    
    static var audioDirectory: URL {
        let url = applicationSupportDirectory.appendingPathComponent("Audio")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        return url
    }
    
    static var mapDirectory: URL {
        let url = applicationSupportDirectory.appendingPathComponent("Map")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        return url
    }
    
    static var feed: URL {
        let string = "https://atfinke.github.io/Magic-Player/Feed-V1.json"
        guard let url = URL(string: string) else { fatalError() }
        return url
    }
    
    static var downloadedAudioItems: URL {
        return applicationSupportDirectory.appendingPathComponent("DownloadedAudioItems.json")
    }
}
