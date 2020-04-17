//
//  FirstViewController.swift
//  ChatBadgeCount
//
//  Created by Barry Carroll on 30/05/2016.
//  Copyright © 2016 chatbadge. All rights reserved.
//

import UIKit
import ZDCChat

class FirstViewController: UIViewController, UITabBarControllerDelegate {

    var currentMessageCount: Int = 0
    var badgeTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grab a reference to the UITabBarItem which shows the badge count.
        badgeTabBarItem = tabBarController?.tabBar.items?[1]
        tabBarController?.delegate = self
    }

    /*
        This method will calculate the number of unread messages and display them on a badge.
    */
    @objc func chatEvent() {
        let newMessageCount = ZDCChat.instance()?.unreadMessagesCount ?? 0
        
        var unreadCount: NSInteger = 0
        
        if (currentMessageCount != 0 && newMessageCount != 0) {
            
            if (newMessageCount > currentMessageCount) {
                
                unreadCount = newMessageCount - currentMessageCount
                badgeTabBarItem.badgeValue = String(unreadCount)
            }
        }
    }
    
    /*
        When this appears we assume that the chat has been hidden. We then start to listen
        for any incoming messages.
    */
    override func viewDidAppear(_ animated: Bool) {
        currentMessageCount = ZDCChat.instance()?.unreadMessagesCount ?? 0
        
        ZDCChatAPI.instance().addObserver(self, forChatLogEvents: #selector(chatEvent))
    }
    
    /*
        When this disappears we assume that we're going back to the chat, so we can 
        assume that we have read all of the unread messages
    */
    override func viewWillDisappear(_ animated: Bool) {
        
        // Reset the unread count and set the badge to nil so it stops showing
        currentMessageCount = 0
        badgeTabBarItem.badgeValue = nil
        
        // Removes the observer because we don't need it
        ZDCChatAPI.instance()?.removeObserver(forChatLogEvents: self)
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // Don't allow the chat to be 'popped under'
        if (tabBarController.selectedIndex == 1 && viewController.isKind(of: UINavigationController.self)) {
            return false
        }
        
        return true
    }
}

