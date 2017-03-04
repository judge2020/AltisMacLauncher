//
//  Click.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import AVFoundation

class ClickSoundHandler{
    var player: AVAudioPlayer?
    func playSound(){
        // Set the sound file name & extension
        let asset = NSDataAsset(name: "sndclick")
        player = try? AVAudioPlayer(data:(asset?.data)!, fileTypeHint:"mp3")
        player?.play()
    }
}
