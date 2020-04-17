//
//  AppDelegate.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit

import AnswerBotProvidersSDK
import ZendeskCoreSDK
import SupportProvidersSDK

import ChatProvidersSDK

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAnswerBot()
        setupChat()
        return true
    }

    private func setupAnswerBot() {
        #warning("Please provide app credentials")
        Zendesk.initialize(appId: "", clientId: "", zendeskUrl: "")
        Support.initialize(withZendesk: Zendesk.instance!)
        AnswerBot.initialize(withZendesk: Zendesk.instance!, support: Support.instance!)
    }

    private func setupChat() {
        #warning("Please provide Chat account key")
        Chat.initialize(accountKey: "")
        Logger.defaultLevel = .verbose // Chat logging
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

