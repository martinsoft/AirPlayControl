//
//  AppleScriptLauncher.swift
//  AirPlayControl
//
//  Created by John Martin on 28/01/2017.
//  Copyright © 2017 Martinsoft Limited. All rights reserved.
//

import Carbon

class AppleScriptLauncher {
    
    enum ScriptExecutionResult {
        /// The application has not been granted to control the UI using Accessibility
        case notTrusted
        /// The operation succeeded
        case success
        /// The operation failed. (TODO: Include a meaningful error)
        case failure
    }
    
    private let scriptURL: URL
    
    init(scriptURL: URL) {
        self.scriptURL = scriptURL
    }
    
    private var hasAccessibilityAccess: Bool {
        let options : NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        return AXIsProcessTrustedWithOptions(options)
    }
    
    func triggerEvent(_ event: String, withParams scriptParams: [String]) -> ScriptExecutionResult {
        
        guard hasAccessibilityAccess else {
            return ScriptExecutionResult.notTrusted
        }
        
        var error: NSDictionary? = nil
        let script = NSAppleScript(contentsOf: scriptURL, error: &error)
        
        // Build event to invoke the 'run' handler in the script
        let handler = NSAppleEventDescriptor(eventClass: AEEventClass(kASAppleScriptSuite),
                                             eventID: AEEventID(kASSubroutineEvent),
                                             targetDescriptor: NSAppleEventDescriptor.null(),
                                             returnID: AEReturnID(kAutoGenerateReturnID),
                                             transactionID: AETransactionID(kAnyTransactionID))
        
        // Convert params into an AppleEventDescriptor
        let params = NSAppleEventDescriptor.list()
        scriptParams.enumerated().forEach { index, param in
            params.insert(NSAppleEventDescriptor(string: param), at: index)
        }
        handler.setDescriptor(params, forKeyword: keyDirectObject)
        
        // Set the name of the event to trigger
        handler.setDescriptor(NSAppleEventDescriptor(string: event), forKeyword: AEKeyword(keyASSubroutineName))
        
        error = nil
        let result = script?.executeAppleEvent(handler, error: &error)
        
        if result == nil {
            if (error != nil) {
                // TODO: What is in the error dictionary? This doesn't seem to be documented?
                // Ideally want to convert this dictionary into a meaningful error on the failure enum case
            }
            return ScriptExecutionResult.failure
        }
        return ScriptExecutionResult.success
    }
    
}
