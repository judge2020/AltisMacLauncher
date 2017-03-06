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
    
    //IBOutlets for storyboard elements
    @IBOutlet var webView: WebView!
    @IBOutlet weak var BackgroundImage: NSImageCell!
    @IBOutlet var DownloadProgress: NSProgressIndicator!
    @IBOutlet var DownloadInfo: NSTextField!
    @IBOutlet var LoginInfo: NSTextField!
    @IBOutlet var UsernameField: NSTextField!
    @IBOutlet var PasswordField: NSSecureTextField!
    
    //go ahead and initialize the things needed.
    let clickSound = ClickSoundHandler()
    let Backg = BackgroundImageHandler()
    let URL = UrlHelperHandler()
    let Notification = NotificationHandler()
    let Login = LoginCheck()
    let DownloadFls = FileDownloader()
    
    //
    //
    //ViewDidLoad: startup code.
    //
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let this = UserDefaults.standard.integer(forKey: "RandBox")
        if (this == 1){
            //rand backgrounds
            Backg.SetRandomBackground(ImageView: BackgroundImage)
        }
        else{
            //startup when new background is chosen
            Backg.SetStartup(ImageView: BackgroundImage)
        }
        
        //load launcher page
        let url = NSURL(string:"https://projectaltis.com/launcher")
        let nsurlreq = NSURLRequest(url: url! as URL)
        webView.mainFrame.load(nsurlreq as URLRequest)
        webView.policyDelegate = self
    }
    
    //redirect anything that's not the launcher page
    func webView(_ webView: WebView!, decidePolicyForNavigationAction actionInformation: [AnyHashable : Any]!, request: URLRequest!, frame: WebFrame!, decisionListener listener: WebPolicyDecisionListener!) {
        if request.url!.absoluteString == "https://projectaltis.com/launcher"{
            listener.use()
        }
        else{
            if (!URL.OpenUrl(url: request.url!.absoluteString)){
                Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.", view: self.view, clickSound: clickSound)
            }
        }
    }
    
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    //
    //
    // play button
    //
    //
    @IBAction func PlayPressed(_ sender: Any) {
        clickSound.playSound()
        //check for fields to be present
        if (UsernameField.stringValue.isEmpty || PasswordField.stringValue.isEmpty){
            Notification.ShowNotification(title: "Invalid Username and password.", details: "Please fill in both fields.", view: self.view, clickSound: clickSound)
            return
        }
        
        //login response
        //rtn.0 = true/false, bool
        //rtn.1 = string info.
        //Probably not the best to house too much stuff in completion handler but oh well.
        Login.VerifyLogin(username: UsernameField.stringValue, password: PasswordField.stringValue, Completion: {rtn in
            print(rtn.0)
            self.LoginInfo.stringValue = rtn.1
        })
        
        
    }
    //
    //
    //Website button. CLick opens URL.
    //
    //
    @IBAction func WebsitePressed(_ sender: Any) {
        clickSound.playSound()
        if (!URL.OpenUrl(url: "https://projectaltis.com")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.", view: self.view, clickSound: clickSound)
        }
    }
    //
    //
    //DIscord button. Click opens url.
    //
    //
    @IBAction func DiscordPressed(_ sender: Any) {
        clickSound.playSound()
        if (!URL.OpenUrl(url: "https://discordapp.com/invite/DNy7E")){
            Notification.ShowNotification(title: "Failure.", details: "Unable to open URL.", view: self.view, clickSound: clickSound)
        }
    }
    //
    //
    //Group tracker plugin. Currently not made.
    //
    //
    @IBAction func GroupTrackerPressed(_ sender: Any) {
        clickSound.playSound()
        Notification.ShowNotification(title: "Not Yet!", details: "This feature has not been made yet. Stay tooned!", view: self.view, clickSound: clickSound)
    
    }
    //
    //
    //themes button. Do not touch, the theme VC is shown via segue.
    //
    //
    @IBAction func ThemePressed(_ sender: Any) {
        clickSound.playSound()
    }
    //
    //
    //options button. May be removed?
    //
    //
    @IBAction func OptionsPressed(_ sender: Any) {
        clickSound.playSound()
    }
    //
    //
    //credits button
    //
    //
    @IBAction func CreditsPressed(_ sender: Any) {
        clickSound.playSound()
        Notification.ShowNotification(title: "Credits", details: "Windows Launcher: Ben\nMac Launcher: Judge2020\n \nCredit to TTR and TTI for kickstarting the Toontown community! \nCredit to the TTPA team for an awesome game!", view: self.view, clickSound: clickSound)
    }
    //
    //
    //Press play button when user hits enter in password field
    //
    //
    @IBAction func PassEnterPressed(_ sender: Any) {
        PlayPressed("LUL")
    }

}
//RadioController is the placeholder name.
//for the themes menu
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

