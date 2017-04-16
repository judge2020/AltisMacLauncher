//
//  ThemeController.swift
//  Project Altis
//
//  Created by Hunter Ray on 4/16/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation
import Cocoa
import AppKit
import AVFoundation
import Foundation
import WebKit

class ThemeController: NSViewController {
    @IBOutlet weak var RandomCheckbox: NSButton!
    
    var nc = NotificationHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let this = UserDefaults.standard.integer(forKey: "RandBox")
        if (this == 1){
            RandomCheckbox.state = NSOnState
        }
        else {
            RandomCheckbox.state = NSOffState
        }
    }
    @IBAction func RandomCheckboxClicked(_ sender: Any) {
        print("TRRIGGERED")
        if (RandomCheckbox.state == NSOnState){
            UserDefaults.standard.set(1, forKey: "RandBox")
            
        }
        else {
            Checkoff()
        }
    }
    @IBAction func TTCPressed(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func MMLPressed(_ sender: Any) {
        UserDefaults.standard.set(2, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func DDOCKPressed(_ sender: Any) {
        UserDefaults.standard.set(3, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func DGPressed(_ sender: Any) {
        UserDefaults.standard.set(4, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func BRRRGHPressed(_ sender: Any) {
        UserDefaults.standard.set(5, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func DDLPressed(_ sender: Any) {
        UserDefaults.standard.set(6, forKey: "pg")
        Checkoff()
        relaunch()
    }
    func notify(){
        nc.ShowNotification(title: "Success!", details: "Background will change with the next restart.")
    }
    func Checkoff(){
        UserDefaults.standard.set(0, forKey: "RandBox")
        RandomCheckbox.state = NSOffState
    }
    func relaunch(){
        let url = NSURL(fileURLWithPath: Bundle.main.resourcePath!) as URL
        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()
        exit(0)
    }
}
