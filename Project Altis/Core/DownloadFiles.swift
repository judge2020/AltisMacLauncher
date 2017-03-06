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
        Alamofire.request("https://projectaltis.com/api/manifest").responseString{response in
            let raw = response.result.value! as String
            let array = raw.components(separatedBy: "#")
            
            //handle update
            for root in array{
                let json = JSON(data: root.data(using: .utf8)!)
                var filename = json["filename"].stringValue
                if (filename.isEmpty) {return}
                
                if (filename =~ "phase_.+\\.mf"){
                    filename = "resources/default/" + filename
                }
                if (filename == "toon.dc"){
                    filename = "config/" + filename
                }
                
                let filepath = (self.dataPath.appendingPathComponent(filename))
                if (!FileManager.default.fileExists(atPath: filepath.path)){
                    print("Missing: " + filename)
                    DispatchQueue.global(qos: .default).async {
                        self.downloadAlamo(path: filepath, url: json["url"].stringValue)
                    }
                }
                else{
                    print("Found: " + filename)
                    
                    //filesize checking for updates
                    let filesize = (try? FileManager.default.attributesOfItem(atPath: filepath.path) as NSDictionary)?.fileSize()
                    if (String(describing: filesize!) != json["size"].string){
                        print("Filesize mismatch, redownloading: " + filename)
                        DispatchQueue.global(qos: .default).async {
                            try? FileManager.default.removeItem(at: filepath)
                            self.downloadAlamo(path: filepath, url: json["url"].stringValue)
                        }
                    }
                    
                }
            }
        }
    }
    func downloadAlamo(path: URL, url: String){
        //let destination = DownloadRequest.suggestedDownloadDestination(for: .applicationSupportDirectory)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = path
            
            return (documentsURL, [.removePreviousFile])
        }
        Alamofire.download(
            url,
            method: .get,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
            }).response(completionHandler: { (DefaultDownloadResponse) in
            })
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
