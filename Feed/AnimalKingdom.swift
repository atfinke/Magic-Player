//
//  AnimalKingdom.swift
//  Feed
//
//  Created by Andrew Finke on 7/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

private let flight: AudioFeedLocation = .init(
    name: "Avatar Flight of Passage",
    coordinate: .init(latitude: 28.355554, longitude: -81.592147),
    items: [
        .init(type: .ride,
              name: "Ride",
              url: URL(string: "https://www.youtube.com/watch?v=5BsLyVWEWzo")!,
              startTime: nil,
              endTime: nil),
])


private let pandora: AudioFeedLand = .init(
    name: "Pandora – The World of Avatar",
    coordinate: .init(latitude: 28.373228, longitude: -81.547489),
    locations: [
        flight
    ],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=p8ov9f8NISk")!,
              startTime: nil,
              endTime: nil),
])

// MARK: - Park -

let animalKingdom: AudioFeedPark = .init(
    name: "Disney's Animal Kingdom",
    coordinate: .init(latitude: 28.3553842507, longitude: -81.5900898529),    
    lands: [
        pandora
])
