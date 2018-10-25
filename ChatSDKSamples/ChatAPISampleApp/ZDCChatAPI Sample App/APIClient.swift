/*
 *
 *  APIClient.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 6/1/16.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

import Foundation
import ZDCChatAPI


/**
 Responsible for handling incoming events from the ChatAPI SDK.
 - Listens for Chat Events and sends them to the event store
 - Listens for Connection Events and updates the UI accordingly
 - Sends messages and uploads images to Zopim
 */
final class APIClient {
  
  fileprivate let chat: ZDCChatAPI
  fileprivate let eventProcessor: ChatEventsProcessor = ChatEventsProcessor()
  
  /// Returns true of the current chat session is in connected status
  var isChatConnected: Bool {
    return chat.connectionStatus == .connected
  }
  
  /**
   Callback that happens when a new event is received
   */
  var eventReceived: ((ChatUIEvent) -> ())?
  
  
  /**
   Callback that happens when an event is updated
   */
  var eventUpdated: ((ChatUIEvent) -> ())?
  
  /**
   Callback that happens when chat connected status is updated
   */
  var chatConnectedStatusUpdated: ((Bool) -> ())?
  
  
  init() {
    
    ZDCLog.enable(true)
    ZDCLog.setLogLevel(ZDCLogLevel.verbose)
    chat = ZDCChatAPI.instance()

    setupListeners()
    
    // Chat -> Click on Profile Avatar -> Check Connection
    let config = ZDCAPIConfig()
    chat.startChat(withAccountKey: "accountKey", config: config)
    
  }
  
  /**
   Setup ZDCChatAPI event listners
   */
  fileprivate func setupListeners() {
    chat.addObserver(self, forChatLogEvents: #selector(chatLogEvent(_:)))
    chat.addObserver(self, forConnectionEvents: #selector(chatConnectionStateUpdate(_:)))
  }
  
  /**
   Ends the current chat
   */
  func endChat() {
    chat.endChat()
  }
  
  /**
   Replay all received chat events if any are available.
   */
  func resumeChatIfNeeded() {
    for event in chat.livechatLog {
      handleChatEvent(event)
    }
  }
  
  
  // MARK : Receiving
  
  /**
   Listens for Chat Log events. These events make up a chat.
   
   - parameter note: NSNotification object. Unused.
   */
  @objc func chatLogEvent(_ note: Notification) {
    let events = chat.livechatLog
    if let lastEvent = events?.last {
      handleChatEvent(lastEvent)
    }
    
  }
  
  /**
   Process ZDCChatEvents, sends them to ChatEventsProcessor.
   
   - parameter event: ZDCChatEvent
   */
  fileprivate func handleChatEvent(_ event: ZDCChatEvent) {
    NSLog("Received chat event \(event.eventId ?? "NO_ID") of type \(event.type.rawValue) with: \(event.message ?? "NO_MSG")")
    
    //Throw away events without timestamps
    if (event.timestamp == nil) {
      return
    }
    
    newEventReceived(event)
  }
  
  func newEventReceived(_ event: ZDCChatEvent) {
    switch eventProcessor.handleEvent(event) {
    case let .new(event):
      eventReceived?(event)
      break
    case let .update(event):
      eventUpdated?(event)
      break
    case .none:
      break
    }
  }
  
  /**
   Listen for chat connection state changes. Only updates when chat connects, any intermediate state is treated as disconnected
   
   - parameter note: NSNotification object. Unused.
   */
  @objc func chatConnectionStateUpdate(_ note: Notification) {
  
    NSLog("Chat connection status updated \(isChatConnected)")
    
    chatConnectedStatusUpdated?(isChatConnected)
  }
  
  
  // MARK : Sending
  /**
   Method to send a string message to Zopim using ZDCChatAPI
   
   - parameter text: the text to send
   */
  func sendMessage(_ text: String) {
    if (self.chat.connectionStatus == ZDCConnectionStatus.connected) {
      chat.sendChatMessage(text)
    } else {
      NSLog("Cannot send message to unconnected chat")
    }
  }

  /**
   Method to upload an image to Zopim using ZDCChatAPI
   
   - parameter image: the image
   */
  func uploadImage(_ image: UIImage) {
    if (self.chat.connectionStatus == ZDCConnectionStatus.connected) {
      chat.uploadImage(image, name: "attachment.jpg")
    } else {
      NSLog("Cannot send message to unconnected chat")
    }
  }
  
  deinit {
    chat.removeObserver(forChatLogEvents: self)
    chat.removeObserver(forConnectionEvents: self)
  }
}
