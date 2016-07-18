/*
 *
 *  AgentMessageCell.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 07/07/2016.
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
import SDWebImage


/// Chat Agent Message Cell
final class AgentMessageCell: MessageChatCell, AgentCellType {
  
  @IBOutlet var agentImage: UIImageView!
  
  override var chatEvent: ChatUIEvent! {
    didSet{
      super.chatEvent = chatEvent
      if let agentEvent = chatEvent as? AgentEventType {
        setAgentAvatar(agentEvent.avatarURL)
      }
    }
  }
}
