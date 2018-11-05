//
//  AppDelegate.swift
//  CocoaPodSample
//
//  Created by Killian Smith on 22/05/2018.
//  Copyright © 2018 Killian Smith. All rights reserved.
//

import UIKit
import ZendeskSDK
import ZendeskCoreSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreLogger.enabled = true
        CoreLogger.logLevel = .debug
        
        // Enter your zendesk app configs here
        Zendesk.initialize(appId: "appId",
                           clientId: "clientId",
                           zendeskUrl: "zendeskUrl")
        
        Support.initialize(withZendesk: Zendesk.instance)
        Zendesk.instance?.setIdentity(Identity.createAnonymous(name: "name", email: "name@email.com"))
        return true
    }
}

