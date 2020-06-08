//
//  AppDelegate.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit
import ChatProvidersSDK

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupZendesk()
        return true
    }

    private func setupZendesk() {
        ZendeskMessaging.setChatLogging(isEnabled: true, logLevel: .verbose)
        Chat.initialize(accountKey: ZendeskMessaging.accountKey)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration",
                             sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
}

