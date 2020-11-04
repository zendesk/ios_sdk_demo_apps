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

final class ZendeskMessaging {
    static let instance = ZendeskMessaging()

    #warning("Please provide Chat account key")
    let accountKey = "<#String#>"

    func initialize() {
        setChatLogging(isEnabled: true, logLevel: .verbose)
        Chat.initialize(accountKey: accountKey)
        Messaging.instance.delegate = self
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
        messagingConfiguration.isMultilineResponseOptionsEnabled = true
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
        chatAPIConfig.tags = ["iOS", "chat_v2"]
        return chatAPIConfig
    }

    // MARK: View Controllers
    func buildMessagingViewController() throws -> UIViewController {
        Chat.instance?.configuration = chatAPIConfig
        return try Messaging.instance.buildUI(engines: engines,
                                              configs: [messagingConfiguration, chatConfiguration])
    }

    // MARK: Connection
    var chat: Chat! { Chat.instance }
    var connectionToken: ChatProvidersSDK.ObservationToken?
    var status: ChatProvidersSDK.ConnectionStatus = .disconnected

    fileprivate func observeConnectionStatus() -> ChatProvidersSDK.ObservationToken? {
        chat.connectionProvider.observeConnectionStatus { [weak self] (status) in
            switch status {
            case .connected:
                print("🎉")
            case .connecting, .reconnecting:
                print("⏳")
            case .disconnected, .failed, .unreachable:
                print("☹️")
            default:
                break
            }
            print(status.description)
            self?.status = status
        }
    }

    private func fireChatAPI(onConnect: @escaping () -> Void) {
        if status.isConnected {
            // If we're connected just fire the API
            onConnect()
            return
        }

        // Else to do a once of connection and fire the API once
        let connectionProvider = chat.connectionProvider
        connectionProvider.connect()
        connectionToken = connectionProvider.observeConnectionStatus { [weak self] (status) in
            guard status == .connected else { return }
            onConnect()
            // Once fired, disconnect after
            connectionProvider.disconnect()
            self?.connectionToken?.cancel()
        }
    }
    
    func isChatting(completion: @escaping ((Bool) -> Void)) {
        fireChatAPI { [weak self] in
            self?.chat.chatProvider.getChatInfo { (result) in
                switch result {
                case .success(let chatInfo):
                    completion(chatInfo.isChatting)
                case .failure(let error):
                    print("getChatInfo failed with error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
}

extension ZendeskMessaging: MessagingDelegate {
    func messaging(_ messaging: Messaging, didPerformEvent event: MessagingUIEvent, context: Any?) {
        switch event {
        case .viewControllerDidClose, .viewDidDisappear:
            let connectionProvider = chat.connectionProvider
            connectionProvider.connect()
            connectionToken = observeConnectionStatus()

        case .viewWillAppear:
            // Remove any event actions that might affect the chat screen
            connectionToken?.cancel()
        default:
            break
        }
    }

    func messaging(_ messaging: Messaging, shouldOpenURL url: URL) -> Bool { true }
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
