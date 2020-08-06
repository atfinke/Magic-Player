//
//  Hollywood Studios.swift
//  Feed
//
//  Created by Andrew Finke on 7/28/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

// MARK: - Hollywood Boulevard -

private let entrance: AudioFeedLocation = .init(
    name: "Entrance",
    coordinate: .init(latitude: 28.358478, longitude: -81.558640),
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=AYQuIx_XcJM")!,
              startTime: nil,
              endTime: nil),
])


private let hollywoodBoulevard: AudioFeedLand = .init(
    name: "Hollywood Boulevard",
    coordinate: .init(latitude: 28.358478, longitude: -81.558640),
    locations: [
        entrance
    ],
    items: nil)


// MARK: - Echo Lake -

private let starTours: AudioFeedLocation = .init(
    name: "Star Tours – The Adventures Continue",
    coordinate: .init(latitude: 28.355695, longitude: -81.558891),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=uNmx4R1bSbI")!,
              startTime: nil,
              endTime: nil),
])

private let echo: AudioFeedLand = .init(
    name: "Echo Lake",
    coordinate: .init(latitude: 28.355695, longitude: -81.558891),
    locations: [
        starTours
    ],
    items: nil)


// MARK: - Star Wars: Galaxy's Edge -

private let galaxyEdge: AudioFeedLand = .init(
    name: "Star Wars: Galaxy's Edge",
    coordinate: .init(latitude: 28.355234, longitude:  -81.559787),
    locations: [],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=3U5rC7AbZ2Y")!,
              startTime: nil,
              endTime: nil)
])

// MARK: - Toy Story Land -

private let mania: AudioFeedLocation = .init(
    name: "Toy Story Mania!",
    coordinate: .init(latitude: 28.356404, longitude: -81.561894),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=joOLgTNMuVU")!,
              startTime: nil,
              endTime: nil),
])

private let toyStoryLand: AudioFeedLand = .init(
    name: "Toy Story Land",
    coordinate: .init(latitude: 28.355949, longitude:  -81.562334),
    locations: [
        mania
    ],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=yD0bK_zwF_w")!,
              startTime: nil,
              endTime: nil),
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=7G5p22_IMPw")!,
              startTime: nil,
              endTime: nil)
])

// MARK: - Animation Courtyard -

private let animationCourtyard: AudioFeedLand = .init(
    name: "Animation Courtyard",
    coordinate: .init(latitude: 28.357667, longitude:  -81.560789),
    locations: [],
    items: [
        .init(type: .area,
              name: "Area",
              url: URL(string: "https://www.youtube.com/watch?v=7YFHnFRCnBA")!,
              startTime: nil,
              endTime: nil)
])

// MARK: - Sunset Boulevard -

private let tower: AudioFeedLocation = .init(
    name: "The Twilight Zone Tower of Terror™",
    coordinate: .init(latitude: 28.359553, longitude: -81.559772),
    items: [
        .init(type: .queue,
              name: "Queue",
              url: URL(string: "https://www.youtube.com/watch?v=Eq-39agXxpA")!,
              startTime: nil,
              endTime: nil)
])

private let fantasmic: AudioFeedLocation = .init(
    name: "Fantasmic!",
    coordinate: .init(latitude: 28.361225150088, longitude: -81.558232605457),
    items: [
        .init(type: .show,
              name: "Soundtrack",
              url: URL(string: "https://www.youtube.com/watch?v=O1Hiwfw0x1k")!,
              startTime: nil,
              endTime: nil)
])


private let sunsetBoulevard: AudioFeedLand = .init(
    name: "Sunset Boulevard",
    coordinate: .init(latitude: 28.359068, longitude: -81.559952),
    locations: [
        tower,
        fantasmic
    ],
    items: nil)


// MARK: - Park -

let hollywoodStudios: AudioFeedPark = .init(
    name: "Disney's Hollywood Studios",
    coordinate: .init(latitude: 28.3584111691, longitude: -81.558689232),
    lands: [
        hollywoodBoulevard,
        echo,
        galaxyEdge,
        toyStoryLand,
        animationCourtyard,
        sunsetBoulevard
])
