//
//  UploadAttachmentAppDelegate.swift
//  support_upload_attachment_sample
//
//  Created by Zendesk on 06/03/2018.
//  Copyright © 2018 Zendesk. All rights reserved.
//

import UIKit
import ZendeskProviderSDK
import ZendeskCoreSDK


@UIApplicationMain
class UploadAttachmentAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /**
         * Initialize the SDK with your Zendesk subdomain, mobile SDK app ID, and client ID.
         *
         * Get these details from your Zendesk dashboard: Admin -> Channels -> MobileSDK.
         */
        Zendesk.initialize(appId: <#appId#>,
                           clientId: <#clientId#>,
                           zendeskUrl: <#zendeskUrl#>)
        
        /**
         * Set an identity (authentication).
         *
         * Set either Anonymous or JWT identity, as below:
         */
        let identity = Identity.createAnonymous()
        
        /*
         let namedIdentity = Identity.createAnonymous(name: "<#Optional name#>", email: "<#Optional email#>")
         let jwtIdentity = Identity.createJwt(token: "<#JWT User Identifier#>")
         */
        
        Zendesk.instance?.setIdentity(identity)
        
        Support.initialize(withZendesk: Zendesk.instance)
        return true
    }
}

