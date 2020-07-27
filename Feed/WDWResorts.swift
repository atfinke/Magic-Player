//
//  WDWResorts.swift
//  Feed
//
//  Created by Andrew Finke on 7/26/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation

private let contemporary: AudioFeedLocation = .init(
    name: "Disney's Contemporary Resort",
    coordinate: .init(latitude: 28.4150447218, longitude: -81.5748066259),
    items: [
        .init(type: .alt,
              name: "Resort TV 2019", url: URL(string: "https://www.youtube.com/watch?v=AK8JljCNr9E")!,
              startTime: nil,
              endTime: nil),
        .init(type: .alt,
              name: "Resort TV 2018", url: URL(string: "https://www.youtube.com/watch?v=PbjVCrCxPZg")!,
              startTime: nil,
              endTime: 2883)
    ])

private let floridian: AudioFeedLocation = .init(
    name: "Disney's Grand Floridian Resort & Spa",
    coordinate: .init(latitude: 28.4109434056, longitude: -81.5878207041),
    items: [
        .init(type: .ride,
              name: "Monorail",
              url: URL(string: "https://www.youtube.com/watch?v=SRTkgRwVtUE")!,
              startTime: nil,
              endTime: nil)
    ])

let waltDisneyWorldOtherLocations = [contemporary, floridian]
