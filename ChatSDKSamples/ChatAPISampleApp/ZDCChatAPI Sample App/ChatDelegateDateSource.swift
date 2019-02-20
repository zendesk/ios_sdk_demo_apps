/*
 *
 *  ChatDelegateDateSource.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 03/12/2014.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

import UIKit
import ZDCChatAPI

struct ChatControllerDelegate: ChatViewControllerDelegate {
  weak var client: APIClient?
  
  func chatController(_ chatController: ChatViewController, sendMessage message: String) {
    client?.sendMessage(message)
  }
  
  func chatController(_ chatController: ChatViewController, didSelectImage image: UIImage) {
    client?.uploadImage(image)
  }
}

/**
 ChatDelegateDateSource connects the ChatViewController to Zopim using an APIClient
 */
final class ChatControllerDataSource: ChatViewControllerDataSource {
  
  fileprivate weak var chatView: ChatView?
  fileprivate weak var client: APIClient?
  
  var chatLog: [ChatUIEvent] {
    didSet {
      chatView?.updateChatLog()
    }
  }
  
  required init (withChatView chatView: ChatView, client: APIClient) {
    self.chatView = chatView
    self.client = client
    
    chatLog = [ChatUIEvent]()
    
    client.chatConnectedStatusUpdated = chatConnectedStatusUpdated
    
    client.eventReceived = { [weak self] event in
      self?.chatLog.append(event)
    }
    
    client.eventUpdated = { [weak self] event in
      
      self?.updateCell(withId: event.id, updateBlock: { (updatedEvent: inout ChatUIEvent) in
        updatedEvent = event
      })
    }
  }
  
  //MARK: APIClient delegate
  
  fileprivate func chatConnectedStatusUpdated(_ state: Bool) {
    chatView?.isChatConnected = state
  }
  
  fileprivate func updateCell(withId id: String, updateBlock: (inout ChatUIEvent) -> ()) {
    guard let (index, item) = chatLog.enumerated().filter({ $1.id == id }).first else { return }
    
    var retItem = item
    updateBlock(&retItem)
    chatLog[index] = retItem
  }
  
}

