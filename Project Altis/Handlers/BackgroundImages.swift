//
//  BackgroundImages.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import Darwin // christian tho

class BackgroundImageHandler {
    func SetBackgroundImage(image: NSImage, ImageView: NSImageCell){
        ImageView.image = image
    }
    
    
    //
    //
    //Random background setting.
    //
    //
    func SetRandomBackground(ImageView: NSImageCell){
        let k = Int.random(lower: 1, upper: 6)
        switch k{
        case 1:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "TTC"), ImageView: ImageView)
            break
        case 2:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "MML"), ImageView: ImageView)
            break
        case 3:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "DG"), ImageView: ImageView)
            break
        case 4:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "DDL"), ImageView: ImageView)
            break
        case 5:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "DD"), ImageView: ImageView)
            break
        case 6:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "Brrrgh.jpg"), ImageView: ImageView)
            break
        default:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "TTC"), ImageView: ImageView)
            break
        }
    }
    //
    //
    //Called when a user does not have random backgrounds. Loads the selected BG based off user settings.
    //
    //
    func SetStartup(ImageView: NSImageCell){
        switch(UserDefaults.standard.integer(forKey: "pg")){
        case 1:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "TTC"), ImageView: ImageView)
            break
        case 2:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "MML"), ImageView: ImageView)
            break
        case 3:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "DD"), ImageView: ImageView)
            break
        case 4:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "DG"), ImageView: ImageView)
            break
        case 5:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "Brrrgh"), ImageView: ImageView)
            break
        case 6:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "DDL"), ImageView: ImageView)
            break
        default:
            self.SetBackgroundImage(image: #imageLiteral(resourceName: "TTC"), ImageView: ImageView)
            break
        }
    }
}





private let _wordSize = __WORDSIZE

public func arc4random<T: ExpressibleByIntegerLiteral>(_ type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, MemoryLayout<T>.size)
    return r
}

public extension UInt {
    public static func random(lower: UInt = min, upper: UInt = max) -> UInt {
        switch (_wordSize) {
        case 32: return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
        case 64: return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
        default: return lower
        }
    }
}

public extension Int {
    public static func random(lower: Int = min, upper: Int = max) -> Int {
        switch (_wordSize) {
        case 32: return Int(Int32.random(lower: Int32(lower), upper: Int32(upper)))
        case 64: return Int(Int64.random(lower: Int64(lower), upper: Int64(upper)))
        default: return lower
        }
    }
}

public extension UInt32 {
    public static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        return arc4random_uniform(upper - lower) + lower
    }
}

public extension Int32 {
    public static func random(lower: Int32 = min, upper: Int32 = max) -> Int32 {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}

public extension UInt64 {
    public static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        let u = upper - lower
        var r = arc4random(UInt64.self)
        
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random(UInt64.self)
        }
        
        return (r % u) + lower
    }
}

public extension Int64 {
    public static func random(lower: Int64 = min, upper: Int64 = max) -> Int64 {
        let (s, overflow) = Int64.subtractWithOverflow(upper, lower)
        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
        let r = UInt64.random(upper: u)
        
        if r > UInt64(Int64.max)  {
            return Int64(r - (UInt64(~lower) + 1))
        } else {
            return Int64(r) + lower
        }
    }
}

public extension Float {
    public static func random(lower: Float = 0.0, upper: Float = 1.0) -> Float {
        let r = Float(arc4random(UInt32.self)) / Float(UInt32.max)
        return (r * (upper - lower)) + lower
    }
}

public extension Double {
    public static func random(lower: Double = 0.0, upper: Double = 1.0) -> Double {
        let r = Double(arc4random(UInt64.self)) / Double(UInt64.max)
        return (r * (upper - lower)) + lower
    }
}
