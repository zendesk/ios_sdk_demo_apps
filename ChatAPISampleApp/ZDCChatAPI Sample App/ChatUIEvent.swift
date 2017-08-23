/*
 *
 *  ChatUIEvent.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 11/07/2016.
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


/**
 Chat Event
 */
protocol ChatUIEvent {
  
  /// Event Unique ID
  var id: String { get }
  
  /// Is event confirmed value
  var confirmed: Bool  { get set }
  
  /// Event Type
  var type: EventType  { get }
  
  /// Event creation timestamp
  var timeStamp: Date { get }
}


/**
 Agent Event Type
 */
protocol AgentEventType {
  
  /// Agent Avatar URL
  var avatarURL: URL? { get }
}


/**
 Chat Message Event Type
 */
protocol ChatMessageEventType: ChatUIEvent {
  
  /// Event Text
  var text: String  { get }
}


/**
 Chat Image Event Type
 */
protocol ChatImageEventType: ChatUIEvent {
  
  /// Event Image
  var image: UIImage?  { get }
  
  /// Event Image URL
  var imageURL: URL? { get }
}


/**
 Chat Visitor Message
 */
struct ChatVisitorMessageEvent: ChatMessageEventType {
  let id: String
  var confirmed: Bool
  let type: EventType = .visitorMessage
  let timeStamp: Date
  let text: String
}


/**
 Chat Agent Message
 */
struct ChatAgentMessageEvent: ChatMessageEventType, AgentEventType {
  let id: String
  var confirmed: Bool
  let type: EventType = .agentMessage
  let timeStamp: Date
  let text: String
  var avatarURL: URL? = nil
}


/**
 Chat Visitor Image
 */
struct ChatVisitorImageEvent: ChatImageEventType {
  let id: String
  var confirmed: Bool
  let type: EventType = .visitorImage
  let timeStamp: Date
  let image: UIImage?
  let imageURL: URL?
}


/**
 Chat Agent Image
 */
struct ChatAgentImageEvent: ChatImageEventType, AgentEventType {
  let id: String
  var confirmed: Bool
  let type: EventType = .agentImage
  let timeStamp: Date
  let image: UIImage?
  let imageURL: URL?
  var avatarURL: URL? = nil
}
