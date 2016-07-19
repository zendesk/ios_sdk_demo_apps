/*
 *
 *  ChatViewControllerDelegate.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 11/07/2016.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zopim Chat SDK, You agree to the Zendesk Terms
 *  of Service https://www.zendesk.com/company/terms and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/application-developer-and-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Chat SDK.
 *
 */

import UIKit


/**
 Protocol that responds to chat view controller actions
 */
protocol ChatViewControllerDelegate {
  
  /**
   Method called when the user wants to upload an image
   
   - parameter chatController: the chat controller
   - parameter image:          the image selected
   */
  func chatController(chatController: ChatViewController, didSelectImage image: UIImage)
  
  /**
   Method called when the user wants to send a message
   
   - parameter chatController: the chat controller
   - parameter message:        the message to send
   */
  func chatController(chatController: ChatViewController, sendMessage message: String)
}

/**
 Chat View Controller Data source delegate
 */
protocol ChatViewControllerDataSource {
  
  /// The list of chat events to display in the chat controller
  var chatLog: [ChatUIEvent] { get set }
}


/**
 Chat View represents an abstraction over a chat view
 */
@objc protocol ChatView {
  
  /**
   Is chat connected
   */
  var isChatConnected: Bool { get set }
  
  /**
   Update the view chat log
   */
  func updateChatLog()
}

