
//
//  LoginCheck.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import AVFoundation
import Alamofire
import SwiftyJSON

class LoginCheck{
    
    //
    //
    //Verify logins with server before trying to download or start game. technically not needed.
    //
    //
    func VerifyLogin(username: String, password: String, Completion: @escaping (Bool, String) -> ()){
        
        //params
        let paramaters: Parameters = [
            "u": username,
            "p": password
        ]
        
        //defaults.
        var returnBool = false
        var returnString = "An unknown errors has occured."
        
        //Request function.
        Alamofire.request("https://projectaltis.com/api/login", method: .post, parameters: paramaters).responseString{response in
            let raw = response.result.value! as String
            print(raw)
            let json = JSON(data: raw.data(using: .utf8)!)
            returnBool = String(describing: json["status"]).toBool()!
            returnString = String(describing: json["reason"])
            Completion(returnBool, returnString)
            return
        }
        //Completion(returnBool, returnString) //May be needed when auth is down.
    }
}

//convert returned str to bool, i think
extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
