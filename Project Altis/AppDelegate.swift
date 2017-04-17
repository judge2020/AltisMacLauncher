//
//  AppDelegate.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Cocoa
import AppKit
import AVFoundation
import Foundation
import WebKit
import XCGLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let URL = UrlHelperHandler()
    let Notification = NotificationHandler()
    let clickSound = ClickSoundHandler()
    
    
    let log = XCGLogger.default
    
    //Stuff with menu bar at the top

    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func MyAccountClick(_ sender: Any) {
        if (!URL.OpenUrl(url: "http://projectalt.is/maclauncher-myaccount")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.")
        }
    }
    @IBAction func InvasionTrackerClick(_ sender: Any) {
        if (!URL.OpenUrl(url: "http://projectalt.is/maclauncher-invasions")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.")
        }
    }
    @IBAction func StreetClick(_ sender: Any) {
        if (!URL.OpenUrl(url: "http://projectalt.is/maclauncher-streets")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.")
        }
    }
    @IBAction func ChagelogClick(_ sender: Any) {
        if (!URL.OpenUrl(url: "http://projectalt.is/maclauncher-changelog")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.")
        }
    }
    @IBAction func ContactClick(_ sender: Any) {
        if (!URL.OpenUrl(url: "mailto:help@projectaltis.com")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open MailTo url.")
        }
    }
    @IBAction func LogClick(_ sender: Any) {
    }
}
