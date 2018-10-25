//
//  AppDelegate.swift
//  AnswerBotSample
//
//  Created by Killian Smith on 27/09/2018.
//  Copyright © 2018 Zendesk. All rights reserved.
//

import UIKit
import ZendeskCoreSDK
import ZendeskProviderSDK
import AnswerBotProvidersSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CoreLogger.enabled = true
        CoreLogger.logLevel = .debug
        
        // Initialize the SDK with your Zendesk instance
        // Get these details from your Zendesk dashboard: Admin -> Channels -> MobileSDK.
         Zendesk.initialize(appId: "appId",
                            clientId: "cleintId",
                            zendeskUrl: "zendeskUrl")
        
        Support.initialize(withZendesk: Zendesk.instance)
        // Support is needed to hand off tickets from AB
        
        // Set an identity for authentication.
         let identity = Identity.createAnonymous()
        // let identity = Identity.createJwt(token: "JWT_User_Identifier")
        Zendesk.instance?.setIdentity(identity)
        
        // Initialize Answer Bot with instances of Zendesk and Support singletons
        guard let support = Support.instance else { return false }
        AnswerBot.initialize(withZendesk: Zendesk.instance, support: support)
        
        return true
    }
}

