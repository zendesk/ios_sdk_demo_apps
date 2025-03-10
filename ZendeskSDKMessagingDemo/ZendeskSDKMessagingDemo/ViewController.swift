//
//  ViewController.swift
//  ZendeskSDKMessagingDemo
//
//  Created by 邓利文 on 2021/5/19.
//

import UIKit
import ZendeskSDKMessaging

class ViewController: UIViewController {

    private enum InitStatus {
        case notReady
        case initializing //initializing
        case ready
        case failed
    }
    
    private var status: InitStatus = .notReady
    private var messaging: ZendeskSDKMessaging.Messaging?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _initMessagingIfNeeded()
    }

    @IBAction func openSupportController(_ sender: Any) {
        _initMessagingIfNeeded { (status) in
            guard status == .ready, let vc = self.messaging?.messagingViewController() else {
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func _initMessagingIfNeeded(_ completion: ((_ status: InitStatus) -> Void)? = nil) {
        if status == .ready || status == .initializing {
            completion?(status)
        } else {
            status = .initializing
            ZendeskSDKMessaging.Messaging.initialize(channelKey: <#T##String#>) { (result) in
                do {
                    self.messaging = try result.get()
                    self.status = .ready
                    completion?(.ready)
                } catch {
                    self.status = .failed
                    completion?(.failed)
                }
            }
        }
    }
    
}

