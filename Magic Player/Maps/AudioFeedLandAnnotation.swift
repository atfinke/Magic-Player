//
//  AudioFeedAnnotation.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/26/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import MapKit

class AudioFeedAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties -
    
    var title: String? {
        return _title
    }
    var coordinate: CLLocationCoordinate2D {
        return _coordinate
    }
    let items: [AudioFeedItem]
    
    private let _title: String?
    private let _coordinate: CLLocationCoordinate2D

    // MARK: - Initalization -
    
    init(title: String, coordinate: DecodableCoordinate, items: [AudioFeedItem]) {
        self._title = title
        self._coordinate = coordinate.cl
        self.items = items
    }
}
