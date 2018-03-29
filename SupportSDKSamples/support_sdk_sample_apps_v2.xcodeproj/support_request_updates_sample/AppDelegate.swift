//
//  AppDelegate.swift
//  support_request_updates_sample
//
//  Created by Killian Smith on 06/03/2018.
//  Copyright © 2018 Killian Smith. All rights reserved.
//

import UIKit
import ZendeskProviderSDK
import ZendeskSDK
import ZendeskCoreSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /**
         * Initialize the SDK with your Zendesk subdomain, mobile SDK app ID, and client ID.
         *
         * Get these details from your Zendesk dashboard: Admin -> Channels -> MobileSDK.
         */
//        Zendesk.initialize(appId: "{applicationId}",
//                           clientId: "{authClientId}",
//                           zendeskUrl: "https://{subdomain}.zendesk.com")
        Zendesk.initialize(appId: "21d4fe078d1a2d39308c18fc4ce86c203882e9f58111ab22",
                           clientId: "mobile_sdk_client_255f79edf6a4e333f45e",
                           zendeskUrl: "https://z3ntestkillian.zendesk.com")

        /**
         * Set an identity (authentication).
         *
         * Set either Anonymous or JWT identity, as below:
         */
        let identity = Identity.createAnonymous()
//        let namedIdentity = Identity.createAnonymous(name: "{Optional name}", email: "{Optional email}")
//        let jwtIdentity = Identity.createJwt(token: "{JWT User Identifier}")
        
        Zendesk.instance?.setIdentity(identity)
        
        ZDKSupport.instance().initialize(with: Zendesk.instance)
        
        return true
    }
}

