//
//  AppDelegate.swift
//  ChatBadgeCount
//
//  Created by Barry Carroll on 30/05/2016.
//  Copyright © 2016 chatbadge. All rights reserved.
//

import UIKit
import ZDCChat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #warning("Hello visitor! Please enter your account key here")
        ZDCChat.initialize(withAccountKey: "{accountKey}")
        
        return true
    }
}

