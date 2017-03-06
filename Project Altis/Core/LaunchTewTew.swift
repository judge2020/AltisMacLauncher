//
//  LaunchTewTew.swift
//  Project Altis
//
//  Created by Hunter Ray on 3/5/17.
//  Copyright © 2017 Judge2020. All rights reserved.
//

import Foundation

class Launcher{
    func LaunchTT(username: String, password: String){
        SetEnvVar(key: "TT_USERNAME", value: username)
        SetEnvVar(key: "TT_PASSWORD", value: password)
        SetEnvVar(key: "TT_GAMESERVER", value: "gs1.projectaltis.com")
    }
    func Execute(path: String){
        Process.launchedProcess(launchPath: path, arguments: [""])
    }
    func SetEnvVar(key: String, value: String){
        setenv(key, value, 1)
    }
}
