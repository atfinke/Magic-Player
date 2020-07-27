//
//  AudioDownloader.swift
//  MapTest
//
//  Created by Andrew Finke on 7/24/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Foundation
import os.log

struct AudioDownloader {
    
    // MARK: - Types -
    
    enum Result {
        case completed(item: AudioFeedItem, fileURL: URL)
        case error(DownloaderError)
    }
    
    enum DownloaderError {
        case localURL
        case uncaughtSignal
        case unknown
    }
    
    // MARK: - Helpers -
    
    static func download(item: AudioFeedItem, onPercentUpdate: @escaping (String) -> Void, completion: @escaping (Result) -> Void) {
        guard let launchPath = Bundle.main.path(forResource: "youtube-dl", ofType: nil),
              let ffmpegPath = Bundle.main.path(forResource: "ffmpeg", ofType: nil),
            let directoryPath = MagicURL
                .audioDirectory
                .absoluteString
                .removingPercentEncoding?
                .replacingOccurrences(of: "file://", with: "") else {
                    completion(.error(.localURL))
            os_log("filesystem issue", log: .audioDownloader, type: .error)
            return
        }
        
        os_log("Using youtube-dl @ %{public}s", log: .audioDownloader, type: .info, launchPath)
        os_log("Using ffmpeg @ %{public}s", log: .audioDownloader, type: .info, ffmpegPath)
        os_log("Using cache directory @ %{public}s", log: .audioDownloader, type: .info, directoryPath)
        
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = MagicURL.audioDirectory.appendingPathComponent(audioFileName)
        os_log("Saving to %{public}s", log: .audioDownloader, type: .info, audioFileURL.absoluteString)
        
        let process = Process()
        process.launchPath = "/usr/bin/python"
        process.currentDirectoryPath = directoryPath
        process.arguments = [
            launchPath,
            item.url.absoluteString,
            "-o",
            audioFileName,
            "-f",
            "bestaudio[ext=m4a]",
            "--ffmpeg-location",
            ffmpegPath
        ]
        
        var trimString = ""
        if let time = item.startTime {
            trimString = "-ss \(time)"
        }
        if let time = item.endTime {
            trimString += " -to \(time)"
        }
        if trimString.isEmpty {
            os_log("Not trimming", log: .audioDownloader, type: .info)
        } else {
            process.arguments?.append(contentsOf: [
               "--postprocessor-args",
                trimString
            ])
            os_log("Trimming: %{public}s", log: .audioDownloader, type: .info, trimString)
        }
        
        os_log("Process args: %{public}s", log: .audioDownloader, type: .info, process.arguments?.description ?? "-")

        let pipe = Pipe()
        process.standardOutput = pipe
        pipe.fileHandleForReading.readabilityHandler = { pipe in
            guard let line = String(data: pipe.availableData, encoding: .utf8), !line.isEmpty else  {
                return
            }
            os_log("Pipe: %{public}s", log: .audioDownloader, type: .debug, line)
            if let percent = line.split(separator: " ").first(where: { $0.contains("%") }) {
                onPercentUpdate(String(percent))
            }
        }

        process.terminationHandler = { process in
            switch process.terminationReason {
            case .exit:
                os_log("Process: exit", log: .audioDownloader, type: .info)
                completion(.completed(item: item, fileURL: audioFileURL))
            case .uncaughtSignal:
                os_log("Process: uncaught signal", log: .audioDownloader, type: .error)
                completion(.error(.uncaughtSignal))
            @unknown default:
                os_log("Process: unknown exit", log: .audioDownloader, type: .error)
                completion(.error(.unknown))
            }
        }
        process.launch()
    }
}
