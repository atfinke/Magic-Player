//
//  OSLog+Magic.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/25/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import os.log

extension OSLog {

    // MARK: - Types -

    private enum CustomCategory: String {
        case audioDownloader, mapTile
    }

    private static let subsystem: String = {
        guard let identifier = Bundle.main.bundleIdentifier else { fatalError() }
        return identifier
    }()

    static let audioDownloader = OSLog(subsystem: subsystem, category: CustomCategory.audioDownloader.rawValue)
    static let mapTile = OSLog(subsystem: subsystem, category: CustomCategory.mapTile.rawValue)

}
