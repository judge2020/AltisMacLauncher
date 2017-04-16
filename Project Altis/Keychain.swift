//
//  Keychain.swift
//  Project Altis
//
//  Created by Hunter Ray on 4/16/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//
import Foundation
import AppKit
import Cocoa
import AVFoundation
import LocalAuthentication

class KeychainHandler{
    private static var _instance : KeychainHandler?
    
    static var Instance : KeychainHandler = {
        if (_instance == nil){
            _instance = KeychainHandler()
        }
        return _instance!
    }()
    
    func SavePasswordKeychain(password: String){
        KeychainSwift.Instance.set(password, forKey: "SecurePassword")
    }
    
    func authenticateUser(reason: String, success: @escaping () -> (), failure: @escaping (String) -> ()) {
        // Get the current authentication context
        let context = LAContext()
        
        if(!TouchIdAvailable()){
            return
        }
        
        
        
        //LAPolicy.deviceOwnerAuthenticationWithBiometrics
        if #available(OSX 10.12.2, *) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication,
                                   localizedReason: reason,
                                   reply: { (status, error) in
                                    if status {
                                        DispatchQueue.main.async {
                                            success()
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            failure("Did not Authenticate")
                                        }
                                    }
            })
        } else {
            failure("Unavailable")
        }
    }
    
    func TouchIdAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        //LAPolicy.deviceOwnerAuthenticationWithBiometrics
        if #available(OSX 10.12.2, *) {
            if(context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error)){
                return true
            }
        } else {
            return false
        }
        return false
    }
    
}
