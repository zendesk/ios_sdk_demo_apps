//
//  SecondViewController.swift
//  ChatBadgeCount
//
//  Created by Barry Carroll on 30/05/2016.
//  Copyright © 2016 chatbadge. All rights reserved.
//

import UIKit
import ZDCChat

class SecondViewController: UIViewController {

    @IBAction func pushChat(sender: AnyObject) {
        
        // Pushes the chat widget onto the navigation controller
        ZDCChat.startChatIn(navigationController, withConfig: nil)
        
        // Hides the back button because we are in a tab controller
        ZDCChat.instance().chatViewController.navigationItem.hidesBackButton = true
    }
}

