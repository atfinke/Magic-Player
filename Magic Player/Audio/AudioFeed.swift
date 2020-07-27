//
//  AudioFeed.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/24/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import CoreLocation

struct DecodableCoordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    var cl: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct AudioFeed: Codable {
    let resorts: [AudioFeedResort]
}

struct AudioFeedResort: Codable {
    
    // MARK: - Properties -
    
    let name: String
    let coordinate: DecodableCoordinate
    let mapTemplateString: String
    let parks: [AudioFeedPark]
    let other: [AudioFeedLocation]
    
    // MARK: Helpers -
    
    func mapURL(for z: Int, x: Int, y: Int) -> URL {
        let urlString = mapTemplateString
            .replacingOccurrences(of: "{z}", with: z.description)
            .replacingOccurrences(of: "{x}", with: x.description)
            .replacingOccurrences(of: "{y}", with: y.description)
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        return url
    }
}

struct AudioFeedPark: Codable {
    let name: String
    let coordinate: DecodableCoordinate
    let lands: [AudioFeedLand]
}

struct AudioFeedLand: Codable {
    let name: String
    let coordinate: DecodableCoordinate
    let locations: [AudioFeedLocation]
    let items: [AudioFeedItem]?
}


struct AudioFeedLocation: Codable {
    let name: String
    let coordinate: DecodableCoordinate
    let items: [AudioFeedItem]
}

struct AudioFeedItem: Codable, Equatable, Identifiable {
    
    // MARK: - Types -
    
    enum ItemType: String, Codable {
        case ride, queue, area, parade, show, alt
    }
    
    // MARK: - Properties -
    
    let type: ItemType
    let name: String
    let url: URL
    
    let startTime: Double?
    let endTime: Double?
    
    var id: String {
        return type.rawValue + name + url.absoluteString
    }
}




