//
//  ZendeskMessaging.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import Foundation
import MessagingSDK
import MessagingAPI
import CommonUISDK
import ChatSDK
import ChatProvidersSDK

final class ZendeskMessaging: NSObject, JWTAuthenticator {

    static let instance = ZendeskMessaging()

    static var themeColor: UIColor? {
        didSet {
            guard let themeColor = themeColor else { return }
            CommonTheme.currentTheme.primaryColor = themeColor
        }
    }

    #warning("Please provide Chat account key")
    let accountKey = "OXgeUeElrZ7hzQ96yrELV4xxlJC91awA"

    var authToken: String = "" {
        didSet {
            guard !authToken.isEmpty else {
                resetVisitorIdentity()
                return
            }
            Chat.instance?.setIdentity(authenticator: self)
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
        chatConfiguration.isPreChatFormEnabled = false
        return chatConfiguration
    }

    var chatAPIConfig: ChatAPIConfiguration {
        let chatAPIConfig = ChatAPIConfiguration()
        chatAPIConfig.tags = ["iOS", "chat_v2"]
        return chatAPIConfig
    }

    // MARK: Chat
    func initialize() {
        setChatLogging(isEnabled: true, logLevel: .verbose)
        Chat.initialize(accountKey: accountKey)
    }

    func setChatLogging(isEnabled: Bool, logLevel: LogLevel) {
        Logger.isEnabled = isEnabled
        Logger.defaultLevel = logLevel
    }

    func resetVisitorIdentity() {
        Chat.instance?.resetIdentity(nil)
    }

    func getToken(_ completion: @escaping (String?, Error?) -> Void) {
        completion(authToken, nil)
    }

    // MARK: View Controller
    func buildMessagingViewController() throws -> UIViewController {
        Chat.instance?.configuration = chatAPIConfig
        return try Messaging.instance.buildUI(engines: engines,
                                              configs: [messagingConfiguration, chatConfiguration])
    }
}

extension ZendeskMessaging {
    // MARK: Engines
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
