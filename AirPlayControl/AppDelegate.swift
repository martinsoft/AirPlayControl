//
//  AppDelegate.swift
//  AirPlayControl
//
//  Created by John Martin on 28/01/2017.
//  Copyright © 2017 Martinsoft Limited. All rights reserved.
//

import Cocoa
import Carbon

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
        
        if let scriptURL = Bundle.main.url(forResource: "airplay", withExtension: "applescript") {
            var error: NSDictionary? = nil
            let script = NSAppleScript(contentsOf: scriptURL, error: &error)

            // Build event to invoke the 'run' handler in the script
            let handler = NSAppleEventDescriptor.init(eventClass: AEEventClass(kASAppleScriptSuite),
                                                      eventID: AEEventID(kASSubroutineEvent),
                                                      targetDescriptor: NSAppleEventDescriptor.null(),
                                                      returnID: AEReturnID(kAutoGenerateReturnID),
                                                      transactionID: AETransactionID(kAnyTransactionID))
            
            
            let params = NSAppleEventDescriptor.list()
            params.insert(NSAppleEventDescriptor(string: deviceName), at: 0)
            
            handler.setDescriptor(params, forKeyword: keyDirectObject)
            handler.setDescriptor(NSAppleEventDescriptor(string: "setAirplay"), forKeyword: AEKeyword(keyASSubroutineName))
            
            error = nil
            let result = script?.executeAppleEvent(handler, error: &error)
            
            if result == nil {
                print("Failed to change AirPlay device")
                if (error != nil) {
                    print("\(error)")
                }
            }
        }
        
        NSApplication.shared().terminate(self)
    }

}

