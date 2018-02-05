//
//  AppDelegate.swift
//  AirPlayControl
//
//  Created by John Martin on 28/01/2017.
//  Copyright © 2017 Martinsoft Limited. All rights reserved.
//

import Foundation
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // First command line argument should be the name of the device to connect to (as it appears in the AirPlay menu).
        guard CommandLine.arguments.count > 1 else {
            terminate(withMessage: "Missing argument. Please specify name of device to connec to")
            return
        }
        let deviceName = CommandLine.arguments[1]

        guard let scriptURL = Bundle.main.url(forResource: "airplay", withExtension: "applescript") else {
            terminate(withMessage: "Missing embedded resource. The application bundle may be corrupt. Please reinstall this application.")
            return
        }
        
        let launcher = AppleScriptLauncher(scriptURL: scriptURL)
        let result = launcher.triggerEvent("setAirPlay", withParams: [deviceName])
        
        switch result {
        case .notTrusted:
            terminate(withMessage: "This application needs your permission to control UI elements through Accessibility. Please ensure this app is enabled in System Preferences > Security & Privacy > Accessibility.")
        case .failure:
            terminate(withMessage: "Failed to change the AirPlay device")
        case .success:
            terminate()
        }
    }
    
    private func terminate(withMessage message: String? = nil) {
        if let msg = message {
            print(msg)
        }
        NSApplication.shared.terminate(self)
    }

}

