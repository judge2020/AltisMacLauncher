//
//  ViewController.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/4/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Cocoa
import AppKit
import AVFoundation
import Foundation
import WebKit

class ViewController: NSViewController, WebPolicyDelegate {
    @IBOutlet var webView: WebView!
    //@IBOutlet var webView: WKWebView!
    @IBOutlet weak var BackgroundImage: NSImageCell!

    let clickSound = ClickSoundHandler()
    let Backg = BackgroundImageHandler()
    let URL = UrlHelperHandler()
    let Notification = NotificationHandler()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let this = UserDefaults.standard.integer(forKey: "RandBox")
        if (this == 1){
            Backg.SetRandomBackground(ImageView: BackgroundImage)
        }
        else{
            Backg.SetStartup(ImageView: BackgroundImage)
        }
        let url = NSURL(string:"https://projectaltis.com/launcher")
        let nsurlreq = NSURLRequest(url: url! as URL)
        webView.mainFrame.load(nsurlreq as URLRequest)
        webView.policyDelegate = self

    }
    
    func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        if request.url!.absoluteString == "https://projectaltis.com/launcher"{
            listener.use()
        }
        else{
            URL.OpenUrl(url: request.url!.absoluteString)
        }
    }
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func PlayPressed(_ sender: Any) {
        clickSound.playSound()
    }
    @IBAction func WebsitePressed(_ sender: Any) {
        clickSound.playSound()
        if (!URL.OpenUrl(url: "https://projectaltis.com")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.", view: self.view, clickSound: clickSound)
        }
    }
    @IBAction func DiscordPressed(_ sender: Any) {
        clickSound.playSound()
        if (!URL.OpenUrl(url: "https://discordapp.com/invite/DNy7E")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.", view: self.view, clickSound: clickSound)
        }
    }
    @IBAction func GroupTrackerPressed(_ sender: Any) {
        clickSound.playSound()
        Notification.ShowNotification(title: "Not Yet!", details: "This feature has not been made yet. Stay tooned!", view: self.view, clickSound: clickSound)
    
    }
    @IBAction func ThemePressed(_ sender: Any) {
        clickSound.playSound()
    }
    @IBAction func OptionsPressed(_ sender: Any) {
        clickSound.playSound()
    }
    @IBAction func CreditsPressed(_ sender: Any) {
        clickSound.playSound()
        Notification.ShowNotification(title: "Credits", details: "Windows Launcher: Ben\nMac Launcher: Judge2020\n \nCredit to TTR and TTI for kickstarting the Toontown community! \nCredit to the TTPA team for an awesome game!", view: self.view, clickSound: clickSound)
    }

}
class RadioController: NSViewController {
    @IBOutlet weak var RandomCheckbox: NSButton!
    
    var vc = ViewController()
    var nc = NotificationHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let this = UserDefaults.standard.integer(forKey: "RandBox")
        if (this == 1){
            RandomCheckbox.state = NSOnState
        }
        else {
            RandomCheckbox.state = NSOffState
        }
    }
    @IBAction func RandomCheckboxClicked(_ sender: Any) {
        print("TRRIGGERED")
        if (RandomCheckbox.state == NSOnState){
            UserDefaults.standard.set(1, forKey: "RandBox")
            
        }
        else {
            Checkoff()
        }
    }
    @IBAction func TTCPressed(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func MMLPressed(_ sender: Any) {
        UserDefaults.standard.set(2, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func DDOCKPressed(_ sender: Any) {
        UserDefaults.standard.set(3, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func DGPressed(_ sender: Any) {
        UserDefaults.standard.set(4, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func BRRRGHPressed(_ sender: Any) {
        UserDefaults.standard.set(5, forKey: "pg")
        Checkoff()
        relaunch()
    }
    @IBAction func DDLPressed(_ sender: Any) {
        UserDefaults.standard.set(6, forKey: "pg")
        Checkoff()
        relaunch()
    }
    func notify(){
        nc.ShowNotification(title: "Success!", details: "Background will change with the next restart.")
    }
    func Checkoff(){
        UserDefaults.standard.set(0, forKey: "RandBox")
        RandomCheckbox.state = NSOffState
    }
    func relaunch(){
        let url = NSURL(fileURLWithPath: Bundle.main.resourcePath!) as URL
        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()
        exit(0)
    }
}

