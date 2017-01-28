//
//  AppDelegate.swift
//  AirPlayControl
//
//  Created by John Martin on 28/01/2017.
//  Copyright © 2017 Martinsoft Limited. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options)
        
        if (!accessibilityEnabled) {
            NSApplication.shared().terminate(self)
        }
        
        let deviceName = CommandLine.arguments[1]
        var source = ""
        
        source += "use AppleScript version \"2.4\" -- Yosemite (10.10) or later" + "\n"
        source += "use scripting additions" + "\n"
        source += "set device_name to \"" + deviceName + "\"" + "\n"
        source += "say device_name" + "\n"
        source += "tell application \"System Events\"" + "\n"
        source += "  tell process \"SystemUIServer\"" + "\n"
        source += "    set display_menu to menu bar item 1 of menu bar 1 whose description contains \"Displays Menu\"" + "\n"
        source += "    click display_menu" + "\n"
        source += "    set the_menu to menu 1 of result" + "\n"
        source += "    delay 1.0" + "\n"
        source += "    if menu item device_name of the_menu exists then" + "\n"
        source += "      click menu item device_name of the_menu" + "\n"
        source += "    else" + "\n"
        source += "      key code 53" + "\n"            // Close the AirPlay menu again if not found
        source += "    end if" + "\n"
        source += "  end tell" + "\n"
        source += "end tell" + "\n"
        
        let script = NSAppleScript(source: source)
        var error: NSDictionary?
        let result = script?.executeAndReturnError(&error)
        
        if result == nil {
            print("Failed to change AirPlay device")
            if (error != nil) {
                print("\(error)")
            }
        }
        NSApplication.shared().terminate(self)
    }

}

