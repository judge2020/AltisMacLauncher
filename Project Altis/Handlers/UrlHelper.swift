//
//  UrlHelper.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import AVFoundation

class UrlHelperHandler {
    //
    //
    //open URL
    //
    //
    func OpenUrl(url: String) -> Bool{
        if let url = URL(string: url), NSWorkspace.shared().open(url) {
            print("Opened URL: ", url)
            return true
        }
        return false
    }
}
