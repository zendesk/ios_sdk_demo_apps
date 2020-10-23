//
//  ViewController.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit
import ChatProvidersSDK

final class ViewController: UIViewController {
    // Press button on Modal to see chat end
    private var modalBackButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .close,
                        target: self,
                        action: #selector(endChat))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startMessaging(_ sender: Any) {
        do {
            let viewController = try ZendeskMessaging.instance.buildMessagingViewController()
            presentModally(viewController)
        } catch {
            print(error)
        }
    }

    private func pushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    private func presentModally(_ viewController: UIViewController,
                                presenationStyle: UIModalPresentationStyle = .automatic) {
        viewController.navigationItem.leftBarButtonItem = modalBackButton

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = presenationStyle
        present(navigationController, animated: true)
    }

    /// Dismiss modal `viewController` action
    @objc private func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc private func endChat() {
        ZendeskMessaging.instance.endChat { (result) in
            // See the logs, or put a breakpoint to see closure is hit
            print("EndChat<Result>: \(result)")
        }
    }
}
