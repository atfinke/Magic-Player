//
//  MagicKingdom.swift
//  Feed
//
//  Created by Andrew Finke on 7/25/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

// MARK: - Main Street, U.S.A. -

private let castle: AudioFeedLocation = .init(
    name: "Happily Ever After",
    coordinate: .init(latitude: 28.4194549043, longitude: -81.5811809),
    items: [
        .init(type: .show,
              name: "Soundtrack",
              url: URL(string: "https://www.youtube.com/watch?v=hQAnJIh6p70")!,
              startTime: nil,
              endTime: nil),
])

private let entrance: AudioFeedLocation = .init(
    name: "Entrance",
    coordinate: .init(latitude: 28.416247, longitude: -81.581209),
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=IyWlxq2kOvw")!,
              startTime: nil,
              endTime: nil),
])

private let electric: AudioFeedLocation = .init(
    name: "Disney's Electrical Parade",
    coordinate: .init(latitude: 28.418277, longitude: -81.581209),
    items: [
        .init(type: .parade,
              name: "Soundtrack",
              url: URL(string: "https://www.youtube.com/watch?v=jlnHJk6PRTY")!,
              startTime: nil,
              endTime: nil),
])

private let mainStreet: AudioFeedLand = .init(
    name: "Main Street, U.S.A.",
    coordinate: .init(latitude: 28.417277, longitude: -81.581209),
    locations: [
        castle,
        entrance,
        electric
    ],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=31YJPz7gZ4c")!,
              startTime: nil,
              endTime: nil)
])

// MARK: - Adventureland -

private let poc: AudioFeedLocation = .init(
    name: "Pirates of the Caribbean",
    coordinate: .init(latitude: 28.41796992, longitude: -81.5842252),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=ZPWt4UCemEQ")!,
              startTime: nil,
              endTime: nil),
        .init(type: .ride,
              name: "Ride",
              url: URL(string: "https://www.youtube.com/watch?v=uY__yQygo3w")!,
              startTime: nil,
              endTime: nil)
])

private let adventureland: AudioFeedLand = .init(
    name: "Adventureland",
    coordinate: .init(latitude: 28.417545, longitude: -81.583274),
    locations: [
        poc
    ],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=muQm1pQI2dc")!,
              startTime: 1,
              endTime: nil)
])


// MARK: - Frontierland -

private let splashMountain: AudioFeedLocation = .init(
    name: "Splash Mountain",
    coordinate: .init(latitude: 28.419418, longitude: -81.584980),
    items: [
        .init(type: .ride,
              name: "Ride",
              url: URL(string: "https://www.youtube.com/watch?v=2qxB2s6MD_Q")!,
              startTime: nil,
              endTime: nil)
])

private let btm: AudioFeedLocation = .init(
    name: "Big Thunder Mountain",
    coordinate: .init(latitude: 28.4199638504, longitude: -81.5846422864),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=zg7SpKuOpkg")!,
              startTime: nil,
              endTime: nil),
        .init(type: .ride,
              name: "Ride",
              url: URL(string: "https://www.youtube.com/watch?v=_UbdTL5PiA0")!,
              startTime: 36,
              endTime: 237)
])

private let frontierland: AudioFeedLand = .init(
    name: "Frontierland",
    coordinate: .init(latitude: 28.419675, longitude:  -81.584019),
    locations: [
        splashMountain,
        btm
    ],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=4IWDQN7jej4")!,
              startTime: nil,
              endTime: nil)
])

// MARK: - Liberty Square -

private let hauntedMansion: AudioFeedLocation = .init(
    name: "Haunted Mansion",
    coordinate: .init(latitude: 28.4202, longitude: -81.58288),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=UT4DEVlNVYA")!,
              startTime: nil,
              endTime: nil),
        .init(type: .ride,
              name: "Ride",
              url: URL(string: "https://www.youtube.com/watch?v=C5zxHZmfNbo")!,
              startTime: 30,
              endTime: 237)
])

private let libertySquare: AudioFeedLand = .init(
    name: "Liberty Square",
    coordinate: .init(latitude: 28.4202, longitude:  -81.58288),
    locations: [
        hauntedMansion
    ],
    items: nil)

// MARK: - Fantasyland -

// MARK: - Tomorrowland -

private let spaceMountain: AudioFeedLocation = .init(
    name: "Space Mountain",
    coordinate: .init(latitude: 28.4188341691, longitude: -81.5781962872),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=OpT83XFX46s")!,
              startTime: nil,
              endTime: nil),
        .init(type: .area,
              name: "Queue Ambient",
              url: URL(string: "https://www.youtube.com/watch?v=a7L_VOOcV64")!,
              startTime: nil,
              endTime: nil)
])


private let tomorrowland: AudioFeedLand = .init(
    name: "Tomorrowland",
    coordinate: .init(latitude: 28.418625, longitude: -81.579106),
    locations: [
        spaceMountain
    ],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=EPO3S649TNs")!,
              startTime: nil,
              endTime: nil)
])

// MARK: - Park -

let magicKingdom: AudioFeedPark = .init(
    name: "Magic Kingdom",
    coordinate: .init(latitude: 28.4160036778, longitude: -81.5811902834),
    lands: [
        mainStreet,
        adventureland,
        frontierland,
        tomorrowland,
        libertySquare
])

