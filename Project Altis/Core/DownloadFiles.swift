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
    func DownloadFilesAndPlayTEWTEW(progress: NSProgressIndicator, info: NSTextField, username: String, password: String){
        
        //initialize queue
        let Queue = OperationQueue()
        
        //maximum download limit
        Queue.maxConcurrentOperationCount = 1
        
        //main request
        Alamofire.request("https://projectaltis.com/api/manifest").responseString{response in
            let raw = response.result.value! as String
            
            //separate each file object
            let array = raw.components(separatedBy: "#")
            
            //handle update
            for root in array{
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
                    let op = DownloadOperation(URLString: json["url"].stringValue, info: info, progress: progress, filename: filename, filePath: filepath, networkOperationCompletionHandler: { responseObject, error in
                        if responseObject == nil {
                            
                            print("failed: \(error)")
                        } else {
                            // update UI to reflect the `responseObject` finished successfully
                            
                            print("responseObject=\(responseObject!)")
                        }
                        
                    })
                    Queue.addOperation(op)
                }
                else{
                    print("Found: " + filename)
                    //if not, check if SHA's are equal
                    if (!self.CompareSha(filePath: filepath.path, hash: json["sha256"].stringValue)){
                        print("SHA256 mismatch for: " + filename)
                        try? FileManager.default.removeItem(at: filepath)
                        let op = DownloadOperation(URLString: json["url"].stringValue, info: info, progress: progress, filename: filename, filePath: filepath, networkOperationCompletionHandler: { responseObject, error in
                            if responseObject == nil {
                                
                                print("failed: \(error)")
                            } else {
                                // update UI to reflect the `responseObject` finished successfully
                                
                                print("responseObject=\(responseObject!)")
                            }
                            
                        })
                        Queue.addOperation(op)
                    }
                    
                }
            }
        }
        Queue.waitUntilAllOperationsAreFinished()
        TTLauncher.LaunchTT(username: username, password: password)
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
//i know we're passing this progress field around so much. it's very abused.
class DownloadOperation: Operation{
    let URLString: String
    let info: NSTextField
    let progress: NSProgressIndicator
    let filename: String
    let filePath: URL
    let networkOperationCompletionHandler: (_ responseObject: Any?, _ error: Error?) -> ()
    
    init(URLString: String, info: NSTextField, progress: NSProgressIndicator, filename: String, filePath: URL, networkOperationCompletionHandler: @escaping (_ responseObject: Any?, _ error: Error?) -> ()) {
        self.URLString = URLString
        self.info = info
        self.progress = progress
        self.filename = filename
        self.filePath = filePath
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
        super.init()
    }
    
    
    // when the operation actually starts, this is the method that will be called
    
    override func main() {
        self.info.stringValue = "Downloading: " + self.filename
        self.info.isEnabled = true
        self.info.isHidden = false
        self.progress.isHidden = false
        self.info.placeholderString = "Downloading: " + self.filename
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = self.filePath
            
            return (documentsURL, [.removePreviousFile])
        }
        Alamofire.download(
            URLString,
            method: .get,
            to: destination).downloadProgress(closure: { (Alamoprogress) in
                self.info.stringValue = "Downloading: " + self.filename
                self.progress.doubleValue = Alamoprogress.fractionCompleted * 100
            }).response(completionHandler: { (DefaultDownloadResponse) in
            })
    }
}

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
