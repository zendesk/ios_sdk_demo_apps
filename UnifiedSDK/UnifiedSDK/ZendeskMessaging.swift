//
//  ZendeskMessaging.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import Foundation

// ViewController and engines
import MessagingSDK
import MessagingAPI

// Theme
import CommonUISDK

// Chat Engine, API and models
import ChatSDK
import ChatProvidersSDK

final class ZendeskMessaging {
    static let instance = ZendeskMessaging()

    #warning("Please provide Chat account key")
    let accountKey = "<#String#>"

    func initialize() {
        setChatLogging(isEnabled: true, logLevel: .verbose)
        Chat.initialize(accountKey: accountKey)
    }

    func setChatLogging(isEnabled: Bool, logLevel: LogLevel) {
        Logger.isEnabled = isEnabled
        Logger.defaultLevel = logLevel
    }

    static var themeColor: UIColor? {
        didSet {
            guard let themeColor = themeColor else { return }
            CommonTheme.currentTheme.primaryColor = themeColor
        }
    }

    // MARK: Configurations
    var messagingConfiguration: MessagingConfiguration {
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Chat Bot"
        return messagingConfiguration
    }

    var chatConfiguration: ChatConfiguration {
        let chatConfiguration = ChatConfiguration()
        chatConfiguration.isAgentAvailabilityEnabled = false
        chatConfiguration.isPreChatFormEnabled = true
        return chatConfiguration
    }

    var chatAPIConfig: ChatAPIConfiguration {
        let chatAPIConfig = ChatAPIConfiguration()
        chatAPIConfig.department = "Sales"
        chatAPIConfig.tags = ["iOS", "chat_v2"]
        return chatAPIConfig
    }

    // MARK: View Controllers
    func buildMessagingViewController() throws -> UIViewController {
        Chat.instance?.configuration = chatAPIConfig
        return try Messaging.instance.buildUI(engines: engines,
                                              configs: [messagingConfiguration, chatConfiguration])
    }
}

// MARK: Engines
extension ZendeskMessaging {

    var engines: [Engine] {
        let engineTypes: [Engine.Type] = [ChatEngine.self]
        return engines(from: engineTypes)
    }

    func engines(from engineTypes: [Engine.Type]) -> [Engine] {
        engineTypes.compactMap { type -> Engine? in
            switch type {
            case is ChatEngine.Type:
                return try? ChatEngine.engine()
            default:
                fatalError("Unhandled engine of type: \(type)")
            }
        }
    }
}
