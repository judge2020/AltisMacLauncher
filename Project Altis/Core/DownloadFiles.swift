//
//  DownloadFiles.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import AVFoundation
import CryptoSwift

class FileDownloader{
    //currently app support/Altis
    //can be changed.
    var dataPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("Altis")
    
    //
    //
    //create missing directories. Will need ot be updated for whatever dirs we need
    //
    //
    func createMissingDirs(){
        do {
            try FileManager.default.createDirectory(atPath: (dataPath.path), withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: (dataPath.appendingPathComponent("config", isDirectory: true)).path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: (dataPath.appendingPathComponent("resources/default", isDirectory: true)).path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        } catch {
            print("other error")
        }
    }
    //
    //
    //download files and compare sha's.
    //
    //
    func DownloadFiles(progress: NSProgressIndicator, info: NSTextField){
        
    }
    
    func CompareSha(filePath: String, hash: String) -> Bool{
        return GetSha(filePath: filePath) == hash
    }
    
    func GetSha(filePath: String) -> String{
        let ths = try? sha256(data: Data(contentsOf: URL(fileURLWithPath: filePath)))
        return ths!.toHexString()
        
    }
    func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
        }
        return Data(bytes: hash)
    }
}
