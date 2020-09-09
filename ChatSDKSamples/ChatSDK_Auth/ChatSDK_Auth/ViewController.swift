//
//  ViewController.swift
//  ChatSDK_Auth
//
//  Created by Killian Smith  on 04/08/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var tokenTextField: UITextField!

    private var modalBackButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .close,
                        target: self,
                        action: #selector(dismissViewController))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
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

    @IBAction func startMessaging(_ sender: Any) {
        do {
            let viewController = try ZendeskMessaging.instance.buildMessagingViewController()
            presentModally(viewController)
        } catch {
            print(error)
        }
    }

    @IBAction func setToken(_ sender: Any) {
        ZendeskMessaging.instance.authToken = tokenTextField.text ?? "" 
    }

    @objc func dismissKeyboard() {
        tokenTextField.resignFirstResponder()
    }
}

