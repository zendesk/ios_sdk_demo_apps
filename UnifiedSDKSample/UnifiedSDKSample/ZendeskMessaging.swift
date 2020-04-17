//
//  ZendeskMessaging.swift
//  UnifiedSDKSample
//
//  Created by Zendesk on 13/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import SwiftUI

// ViewController and Engines
import MessagingSDK
import MessagingAPI

// Theme
import CommonUISDK

// Product engines
import ChatSDK
import AnswerBotSDK

// Chat API and models
import ChatProvidersSDK

struct MessagingView: View {
    let themeColor: UIColor?
    let answerBotEnabled: Bool
    let chatEnabled: Bool

    var body: some View {
        MessagingController(themeColor: themeColor, answerBotEnabled: answerBotEnabled, chatEnabled: chatEnabled)
    }
}

struct MessagingController: UIViewControllerRepresentable {
    var controllers: [UIViewController] = []
    var themeColor: UIColor?
    var answerBotEnabled: Bool
    var chatEnabled: Bool

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

        let name = "iOS User_\(UUID().uuidString)"
        chatAPIConfig.visitorInfo = VisitorInfo(name: name, email: "test@email.com", phoneNumber: "")
        return chatAPIConfig
    }

    // MARK: Theme
    func updateMessagingStyling() {
        guard let themeColor = themeColor else { return }
        CommonTheme.currentTheme.primaryColor = themeColor
    }

    // MARK: View Controller
    func buildMessagingViewController() throws -> UIViewController {
        try Messaging.instance.buildUI(engines: engines, configs: [messagingConfiguration, chatConfiguration])
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                 context: UIViewControllerRepresentableContext<MessagingController>) {
     }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MessagingController>) -> UIViewController {
        do {
            Chat.instance?.configuration = chatAPIConfig
            updateMessagingStyling()
            return try buildMessagingViewController()
        } catch  {
            fatalError("Failed to create viewController")
        }
    }
}

// MARK: Engines
extension MessagingController {

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
