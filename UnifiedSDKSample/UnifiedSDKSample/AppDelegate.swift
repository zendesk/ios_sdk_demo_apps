//
//  AppDelegate.swift
//  UnifiedSDKSample
//
//  Created by Zendesk on 13/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit

import ChatProvidersSDK

import AnswerBotProvidersSDK
import ZendeskCoreSDK
import SupportProvidersSDK

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAnswerBot()
        setupZendesk()

        return true
    }

    private func setupAnswerBot(){
        #error("Please provide app credentials")
        Zendesk.initialize(appId: "", clientId: "", zendeskUrl: "")
        Support.initialize(withZendesk: Zendesk.instance!)
        AnswerBot.initialize(withZendesk: Zendesk.instance!, support: Support.instance!)
    }

    private func setupZendesk(){
        #error("Please provide Chat account key")
        Chat.initialize(accountKey: "")
        Logger.defaultLevel = .verbose // Chat logging
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

