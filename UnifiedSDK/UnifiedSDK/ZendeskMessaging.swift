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

import AnswerBotSDK

// Chat Engine, API and models
import ChatSDK
import ChatProvidersSDK

struct ZendeskMessaging {
    let themeColor: UIColor?

    let answerBotEnabled: Bool
    let chatEnabled: Bool

    // MARK: Configurations
    var messagingConfiguration: MessagingConfiguration {
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Chat Bot"
        return messagingConfiguration
    }

    var chatConfiguration: ChatConfiguration {
        let chatConfiguration = ChatConfiguration()
        chatConfiguration.chatMenuActions = [.emailTranscript]
        chatConfiguration.isAgentAvailabilityEnabled = false
        return chatConfiguration
    }

    var chatAPIConfig: ChatAPIConfiguration {
        let chatAPIConfig = ChatAPIConfiguration()
        chatAPIConfig.department = "Sales"
        chatAPIConfig.tags = ["iOS", "chat_v2"]
        chatAPIConfig.visitorInfo = VisitorInfo(name: "iOS_User", email: "test@email.com", phoneNumber: "")
        return chatAPIConfig
    }

    // MARK: Theme
    private func updateMessagingStyling() {
        guard let themeColor = themeColor else { return }
        CommonTheme.currentTheme.primaryColor = themeColor
    }

    // MARK: View Controllers
    func buildMessagingViewController() throws -> UIViewController {
        Chat.instance?.configuration = chatAPIConfig
        updateMessagingStyling()
        return try Messaging.instance.buildUI(engines: engines,
                                              configs: [messagingConfiguration, chatConfiguration])
    }
}

// MARK: Engines
extension ZendeskMessaging {
    var engines: [Engine] {
        var engineTypes = [Engine.Type]()

        if answerBotEnabled {
            engineTypes.append(AnswerBotEngine.self)
        }

        if chatEnabled {
            engineTypes.append(ChatEngine.self)
        }
        return engines(from: engineTypes)
    }

    func engines(from engineTypes: [Engine.Type]) -> [Engine] {
        engineTypes.compactMap { type -> Engine? in
            switch type {
            case is AnswerBotEngine.Type:
                return try? AnswerBotEngine.engine()
            case is ChatEngine.Type:
                return try? ChatEngine.engine()
            default:
                fatalError("Unhandled engine of type: \(type)")
            }
        }
    }
}
