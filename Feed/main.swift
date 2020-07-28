//
//  main.swift
//  Feed
//
//  Created by Andrew Finke on 7/24/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

let date = Date()
let waltDisneyWorld: AudioFeedResort = .init(
    name: "Walt Disney World",
    coordinate: .init(latitude: 28.388195, longitude: -81.569324),
    mapTemplateString: "https://cdn6.parksmedia.wdprapps.disney.com/media/maps/prod/wdw/152/{z}/{x}/{y}.jpg",
    parks: [
        magicKingdom,
        epcot,
        hollywoodStudios,
        animalKingdom
    ],
    other: waltDisneyWorldOtherLocations)

let disneylandResort: AudioFeedResort = .init(
    name: "Disneyland Resort",
    coordinate: .init(latitude: 33.8105, longitude: -117.9190),
    mapTemplateString: "https://cdn6.parksmedia.wdprapps.disney.com/media/maps/prod/disneyland/83/{z}/{x}/{y}.jpg",
    parks: [],
    other: [])

let feed: AudioFeed = .init(resorts: [
    waltDisneyWorld,
    disneylandResort
])

guard let data = try? JSONEncoder().encode(feed) else { fatalError() }

// remember to change the post-run action if changing the file name
let url = URL(fileURLWithPath: "./Feed-V1.json")
try! data.write(to: url)
print(-date.timeIntervalSinceNow)
