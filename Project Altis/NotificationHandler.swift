//
//  NotificationHandler.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import AVFoundation

class NotificationHandler{
    //
    //
    //Notification, attached to window
    //
    //
    func ShowNotification(title: String, details: String, view: NSView, clickSound: ClickSoundHandler){
        let alert = NSAlert()
        alert.messageText = title
        alert.addButton(withTitle: "Ok")
        alert.informativeText = details
        
        alert.beginSheetModal(for: view.window!, completionHandler: { [unowned self] (returnCode) -> Void in
            if returnCode == NSAlertFirstButtonReturn {
                clickSound.playSound()
            }
        })
    }
    //
    //
    //Notification, free floating
    //
    //
    func ShowNotification(title: String, details: String){
        let alert = NSAlert()
        alert.messageText = title
        alert.addButton(withTitle: "Ok")
        alert.informativeText = details
        
        alert.runModal()
    }
}
