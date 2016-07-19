/*
 *
 *  APIClient.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 6/1/16.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zopim Chat SDK, You agree to the Zendesk Terms
 *  of Service https://www.zendesk.com/company/terms and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/application-developer-and-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Chat SDK.
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
  
  private let chat: ZDCChatAPI
  private let eventProcessor: ChatEventsProcessor = ChatEventsProcessor()
  
  /// Returns true of the current chat session is in connected status
  var isChatConnected: Bool {
    return chat.connectionStatus == .Connected
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
    ZDCLog.setLogLevel(ZDCLogLevel.Verbose)
    chat = ZDCChatAPI.instance()

    setupListeners()
    
    let config = ZDCAPIConfig()
    chat.startChatWithAccountKey("2PT4TD5ox8d19nrLoBAGpMk87L4r4VQQ", config: config)
    
  }
  
  /**
   Setup ZDCChatAPI event listners
   */
  private func setupListeners() {
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
  @objc func chatLogEvent(note: NSNotification) {
    let events = chat.livechatLog
    if let lastEvent = events.last {
      handleChatEvent(lastEvent)
    }
    
  }
  
  /**
   Process ZDCChatEvents, sends them to ChatEventsProcessor.
   
   - parameter event: ZDCChatEvent
   */
  private func handleChatEvent(event: ZDCChatEvent) {
    NSLog("Received chat event \(event.eventId) of type \(event.type.rawValue) with: \(event.message)")
    
    //Throw away events without timestamps
    if (event.timestamp == nil) {
      return
    }
    
    newEventReceived(event)
  }
  
  func newEventReceived(event: ZDCChatEvent) {
    switch eventProcessor.handleEvent(event) {
    case let .New(event):
      eventReceived?(event)
      break
    case let .Update(event):
      eventUpdated?(event)
      break
    case .None:
      break
    }
  }
  
  /**
   Listen for chat connection state changes. Only updates when chat connects, any intermediate state is treated as disconnected
   
   - parameter note: NSNotification object. Unused.
   */
  @objc func chatConnectionStateUpdate(note: NSNotification) {
  
    NSLog("Chat connection status updated \(isChatConnected)")
    
    chatConnectedStatusUpdated?(isChatConnected)
  }
  
  
  // MARK : Sending
  /**
   Method to send a string message to Zopim using ZDCChatAPI
   
   - parameter text: the text to send
   */
  func sendMessage(text: String) {
    if (self.chat.connectionStatus == ZDCConnectionStatus.Connected) {
      chat.sendChatMessage(text)
    } else {
      NSLog("Cannot send message to unconnected chat")
    }
  }

  /**
   Method to upload an image to Zopim using ZDCChatAPI
   
   - parameter image: the image
   */
  func uploadImage(image: UIImage) {
    if (self.chat.connectionStatus == ZDCConnectionStatus.Connected) {
      chat.uploadImage(image, name: "attachment.jpg")
    } else {
      NSLog("Cannot send message to unconnected chat")
    }
  }
  
  deinit {
    chat.removeObserverForChatLogEvents(self)
    chat.removeObserverForConnectionEvents(self)
  }
}
