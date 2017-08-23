/*
 *
 *  ZopimMessageFactory.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 6/14/16.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

import ZDCChatAPI

/**
 Converts ZDCChatEvent to ChatItem for use by the UI
 */
extension ZDCChatEvent {
  
  var chatItem: ChatUIEvent {
    let date = Date.init(timeIntervalSince1970: self.timestamp.doubleValue / 1000.0)
    let url = self.attachment?.url == nil ? nil : URL(string: self.attachment.url)
    let image = self.fileUpload?.image
    
    switch self.type {
    case .agentMessage:
      return ChatAgentMessageEvent(id: self.eventId,
                                   confirmed: self.verified,
                                   timeStamp: date,
                                   text: self.message,
                                   avatarURL: nil)
    case .visitorMessage:
      return ChatVisitorMessageEvent(id: self.eventId,
                                     confirmed: self.verified,
                                     timeStamp: date,
                                     text: self.message)
    case .visitorUpload:
      let confirmed = self.fileUpload.status == .complete
      return ChatVisitorImageEvent(id: self.eventId,
                                   confirmed: confirmed,
                                   timeStamp: date,
                                   image: image,
                                   imageURL: url)
    case .agentUpload:
      return ChatAgentImageEvent(id: self.eventId,
                                 confirmed: true,
                                 timeStamp: date,
                                 image: image,
                                 imageURL: url,
                                 avatarURL: nil)
      
    default:
      assert(false, "Type not supported")
    }
  }
}
