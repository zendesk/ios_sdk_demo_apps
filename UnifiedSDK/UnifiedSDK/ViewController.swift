//
//  ViewController.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var answerBotSwitch: UISwitch!
    @IBOutlet private weak var chatSwitch: UISwitch!

    private var themeColor: UIColor?

    private var answerBotEnabled: Bool { answerBotSwitch.isOn }
    private var chatEnabled: Bool { chatSwitch.isOn }

    private var zendeskWrapper: ZendeskMessaging {
        ZendeskMessaging(themeColor: themeColor, answerBotEnabled: answerBotEnabled, chatEnabled: chatEnabled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startMessaging(_ sender: Any) {
        do {
            let viewController = try zendeskWrapper.buildMessagingViewController()
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated: true)
        } catch {
            print(error)
        }
    }
}
