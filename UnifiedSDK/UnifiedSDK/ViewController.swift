//
//  ViewController.swift
//  UnifiedSDK
//
//  Created by Zendesk on 17/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    var zendesk: ZendeskMessaging?

    private var modalBackButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .close,
                        target: self,
                        action: #selector(dismissViewController))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissViewController()
        zendesk = ZendeskMessaging()
    }

    @IBAction func startMessaging(_ sender: Any) {
        do {
            let viewController = try zendesk!.buildMessagingViewController()
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

    deinit {
        zendesk = nil
    }
}
