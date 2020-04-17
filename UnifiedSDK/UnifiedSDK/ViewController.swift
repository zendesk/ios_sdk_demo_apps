//
//  ViewController.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let zendeskWrapper = ZendeskMessaging(themeColor: nil)
    private weak var zendeskNavigationController: UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startMessaging(_ sender: Any) {
        do {
            let viewController = try zendeskWrapper.buildMessagingViewController()
            let chatNavigationController = UINavigationController(rootViewController: viewController)
            zendeskNavigationController = chatNavigationController
            present(chatNavigationController, animated: true)
        } catch {
            print(error)
        }
    }
}
