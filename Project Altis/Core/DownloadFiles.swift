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
import Alamofire
import SwiftyJSON


class FileDownloader{
    //currently app support/Altis
    //can be changed.
    var dataPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("Altis")
    
    let TTLauncher = Launcher()
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
    
    var done = 0
    var needed = 0
    var noDLNeeded = false
    
    func DownloadFilesAndPlayTEWTEW(progress: NSProgressIndicator, info: NSTextField, username: String, password: String){
        
        //initialize queue
        //main request
        
        let queue = DispatchQueue(label: "q")
        let semaphore = DispatchSemaphore(value: 1)
        
        
        Alamofire.request("https://projectaltis.com/api/manifest").responseString{response in
            
            
            
            let raw = response.result.value! as String
            
            
            
            //separate each file object
            let array = raw.components(separatedBy: "#")
            
            
            //handle update
            for root in array{
                
                //if end of loop, check if there isn't a Download needed. Requires an trailing #pound to reliably work
                if (root == "" && self.needed == 0){
                    info.stringValue = "Have fun!"
                    print("Launching toontown")
                    self.TTLauncher.LaunchTT(username: username, password: password)
                }
                
                
                let json = JSON(data: root.data(using: .utf8)!)
                
                //filename
                var filename = json["filename"].stringValue
                if (filename.isEmpty) {return}
                
                // ~= is regex match
                if (filename =~ "phase_.+\\.mf"){
                    filename = "resources/default/" + filename
                }
                if (filename == "toon.dc"){
                    filename = "config/" + filename
                }
                
                let filepath = (self.dataPath.appendingPathComponent(filename))
                
                //check if file exists
                if (!FileManager.default.fileExists(atPath: filepath.path)){
                    print("Missing: " + filename)
                    
                    //download code
                    self.needed += 1
                    
                    queue.async {
                        semaphore.wait()
                        
                        print("Started downloading " + filename)
                        info.stringValue = "Downloading: " + filename
                        info.placeholderString = "Downloading: " + filename
                        info.isEnabled = true
                        info.isHidden = false
                        progress.isHidden = false
                        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                            let documentsURL = filepath
                            return (documentsURL, [.removePreviousFile])
                        }
                        Alamofire.download( json["url"].stringValue, method: .get, to: destination)
                            .downloadProgress{ Alamoprogress in
                                info.stringValue = "Downloading: " + filename
                                info.placeholderString = "Downloading: " + filename
                                progress.doubleValue = Alamoprogress.fractionCompleted * 100
                            }
                            .response { response in
                                semaphore.signal()
                                print("Done downloading: " + filename)
                                self.done += 1
                                self.CheckDownloadsDone(info: info, username: username, password: password)
                                
                        }
                    }
                    

                    
                    
                    
                    //end dl code
                }
                else{
                    print("Found: " + filename)
                    //if not, check if SHA's are equal
                    if (!self.CompareSha(filePath: filepath.path, hash: json["sha256"].stringValue)){
                        print("SHA256 mismatch for: " + filename)
                        try? FileManager.default.removeItem(at: filepath)
                        
                        
                        //download code
                        
                        self.needed += 1
                        
                        queue.async {
                            semaphore.wait()
                            
                            print("Started downloading " + filename)
                            info.stringValue = "Downloading: " + filename
                            info.placeholderString = "Downloading: " + filename
                            info.isEnabled = true
                            info.isHidden = false
                            progress.isHidden = false
                            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                                let documentsURL = filepath
                                return (documentsURL, [.removePreviousFile])
                            }
                            Alamofire.download( json["url"].stringValue, method: .get, to: destination)
                                .downloadProgress{ Alamoprogress in
                                    info.stringValue = "Downloading: " + filename
                                    progress.doubleValue = Alamoprogress.fractionCompleted * 100
                                }
                                .response { response in
                                    
                                    
                                    print("Done downloading: " + filename)
                                    
                                    self.done += 1
                                    semaphore.signal()
                                    self.CheckDownloadsDone(info: info, username: username, password: password)
                                    
                            }
                        }
                        
                        
                        
                        
                        
                        //end dl code
                        
                    }
                    else{
                        print("SHA match for: " + filename)
                    }
                    
                }
                
            }
            
        }
        
        info.stringValue = "Verifying files..."

    }
    
    func CheckDownloadsDone(info: NSTextField, username: String, password: String){
        if (self.done != 0 && self.needed != 0 && self.needed == self.done){
            info.stringValue = "Have fun!"
            print("Launching toontown")
            self.TTLauncher.LaunchTT(username: username, password: password)
        }
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


//regex easy handler
class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: [])
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matches(in: input, options: [], range:NSRange(location: 0, length: input.characters.count))
        return matches.count > 0
    }
}

infix operator =~
func =~ (input: String, pattern: String) -> Bool {
    return Regex(pattern).test(input: input)
}
