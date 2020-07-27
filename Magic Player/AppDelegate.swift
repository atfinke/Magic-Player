//
//  AppDelegate.swift
//  Magic Player
//
//  Created by Andrew Finke on 7/24/20.
//  Copyright © 2020 Andrew Finke. All rights reserved.
//

import Cocoa
import MediaPlayer

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        guard let window = sender.windows.first else {
            return true
        }
        
        if flag {
            window.orderFront(nil)
        } else {
            window.makeKeyAndOrderFront(nil)
        }
        return true
    }
    
    func applicationWillBecomeActive(_ notification: Notification) {
        MPNowPlayingInfoCenter.default().playbackState = .playing // I am the captain now
    }
}

