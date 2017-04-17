//
//  OptionsController.swift
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

class OptionsController : NSViewController {
    
    @IBOutlet var Keychainbox: NSButton!
    @IBOutlet var Touchidbox: NSButton!
    @IBOutlet var SaveLoginBox: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //update stuff mbased on userdefaults
        
        if(UserDefaults.standard.bool(forKey: "Keychain")){
            Keychainbox.state = NSOnState
        }
        
        if(UserDefaults.standard.integer(forKey: "savelogin") == 1){
            SaveLoginBox.state = NSOnState
        }
        
        UpdateTouchIdBox()
    }
    
    @IBAction func KeychainPressed(_ sender: Any) {
        UpdateTouchIdBox()
        if (Keychainbox.state == NSOnState){
            UserDefaults.standard.set(true, forKey: "Keychain")
        }
        else{
            UserDefaults.standard.set(false, forKey: "Touchid")
            Touchidbox.state = NSOffState
            UserDefaults.standard.set(false, forKey: "Keychain")
        }
    }
    
    @IBAction func TouchidPressed(_ sender: Any) {
        
        if(Touchidbox.state == NSOnState){
            KeychainHandler.Instance.authenticateUser(reason: "confirm your fingerprint", success: {
                self.Keychainbox.state = NSOnState
                UserDefaults.standard.set(true, forKey: "Touchid")
            }, failure: {_ in
                self.Touchidbox.state = NSOffState
            })
        }
        else{
            UserDefaults.standard.set(false, forKey: "Touchid")
        }
        UpdateTouchIdBox()
    }
    
    @IBAction func CheckBoxSaveChange(_ sender: Any) {
        print("TRIGGERED")
        if (SaveLoginBox.state == NSOnState){
            UserDefaults.standard.set(1, forKey: "savelogin")
            return
        }
        UserDefaults.standard.set(0, forKey: "savelogin")
    }
    
    func UpdateTouchIdBox(){
        let avail = KeychainHandler.Instance.TouchIdAvailable()
        let state = Keychainbox.state == NSOnState
        let userdefault = UserDefaults.standard.bool(forKey: "Touchid")
        if(avail && state){
            Touchidbox.isEnabled = true
            if(userdefault){
                Touchidbox.state = NSOnState
            }
        }
        else{
            Touchidbox.isEnabled = false
        }
    }
    
}
