//
//  DownloadedAudioItems.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/25/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

class DownloadedAudioItems: Codable {
    
    // MARK: - Types -
    
    private struct Item: Codable {
        let item: AudioFeedItem
        let fileURL: URL
    }
    
    private var items = [Item]()
    
    // MARK: - Helpers -
    
    static func loadFromDisk() -> DownloadedAudioItems {
        guard let data = try? Data(contentsOf: MagicURL.downloadedAudioItems), let items = try? JSONDecoder().decode(DownloadedAudioItems.self, from: data) else {
            return DownloadedAudioItems()
        }
        return items
    }
    
    func fileURL(for item: AudioFeedItem) -> URL? {
        guard let url = items.first(where: { $0.item == item })?.fileURL else { return nil }
        return url
    }
    
    func downloaded(item: AudioFeedItem, to fileURL: URL) {
        let downloadedItem = Item(item: item, fileURL: fileURL)
        items.append(downloadedItem)
        
        guard let data = try? JSONEncoder().encode(self) else {
            return
        }
        try? data.write(to:  MagicURL.downloadedAudioItems)
    }
    
}
