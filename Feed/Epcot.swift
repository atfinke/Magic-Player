//
//  Epcot.swift
//  Feed
//
//  Created by Andrew Finke on 7/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

private let testTrack: AudioFeedLocation = .init(
    name: "Test Track",
    coordinate: .init(latitude: 28.373228, longitude: -81.547489),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=2RdzAoW5kxA")!,
              startTime: nil,
              endTime: nil),
        .init(type: .ride,
              name: "Ride",
              url: URL(string: "https://www.youtube.com/watch?v=l8rPapPZKRw")!,
              startTime: 12,
              endTime: nil),
])

private let soarin: AudioFeedLocation = .init(
    name: "Soarin' Over California",
    coordinate: .init(latitude: 28.373592, longitude: -81.552248),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=Tm5fcLgN9r0")!,
              startTime: nil,
              endTime: nil),
        .init(type: .alt,
              name: "Exit",
              url: URL(string: "https://www.youtube.com/watch?v=Jj_aPT97Hzk")!,
              startTime: nil,
              endTime: nil),
        .init(type: .ride,
              name: "Ride",
              url: URL(string: "https://www.youtube.com/watch?v=QG_nklaYefE")!,
              startTime: nil,
              endTime: nil)
])

private let futureWorld: AudioFeedLand = .init(
    name: "Future World",
    coordinate: .init(latitude: 28.373228, longitude: -81.547489),
    locations: [
        testTrack,
        soarin
    ],
    items: nil)

private let illuminations: AudioFeedLocation = .init(
    name: "IllumiNations: Reflections of Earth",
    coordinate: .init(latitude: 28.370146, longitude: -81.549394),
    items: [
        .init(type: .show,
              name: "Soundtrack",
              url: URL(string: "https://www.youtube.com/watch?v=vlJuGva4Xo4")!,
              startTime: nil,
              endTime: nil),
])

private let showcase: AudioFeedLand = .init(
    name: "World Showcase",
    coordinate: .init(latitude: 28.370146, longitude: -81.549394),
    locations: [
        illuminations
    ],
    items: nil)

// MARK: - Park -

let epcot: AudioFeedPark = .init(
    name: "Disney's Hollywood Studios",
    coordinate: .init(latitude: 28.4160036778, longitude: -81.5811902834),
    lands: [
        futureWorld,
        showcase
])
