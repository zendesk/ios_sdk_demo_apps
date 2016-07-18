/*
 *
 *  ChatDelegateDateSource.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 03/12/2014.
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
 ChatDelegateDateSource connects the ChatViewController to Zopim using an APIClient
 */
final class ChatDelegateDateSource: ChatViewControllerDataSource, ChatViewControllerDelegate, APIClientProtocol {
  
  private let chatView: ChatView
  private var client: APIClient!
  
  var chatLog: [ChatUIEvent] {
    didSet {
      chatView.updateChatLog()
    }
  }
  
  required init (withChatView chatView: ChatView) {
    self.chatLog = [ChatUIEvent]()
    self.chatView = chatView
    self.client = APIClient(withDelegate: self)
  }
  
  private func updateCell(withId id: String, updateBlock: (inout ChatUIEvent) -> ()) {
    guard let (index, item) = chatLog.enumerate().filter({ $1.id == id }).first else { return }
    
    var retItem = item
    updateBlock(&retItem)
    chatLog[index] = retItem
  }

  
  func chatController(chatController: ChatViewController, sendMessage message: String) {
    client.sendMessage(message)
  }
  
  func chatController(chatController: ChatViewController, didSelectImage image: UIImage) {
    client.uploadImage(image)
  }
  
  //MARK: APIClient delegate
  
  func newEvent(event: ChatUIEvent) {
    chatLog.append(event)
  }
  
  func updateEvent(updatedEvent: ChatUIEvent) {
    updateCell(withId: updatedEvent.id, updateBlock: { (inout event: ChatUIEvent) in
      event = updatedEvent
    })
  }
  
  func updateChatState(state: Bool) {
    chatView.updateConnectionState(state)
  }
  
}

