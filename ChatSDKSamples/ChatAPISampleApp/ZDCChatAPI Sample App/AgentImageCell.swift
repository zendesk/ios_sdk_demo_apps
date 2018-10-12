/*
 *
 *  AgentImageCell.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 08/07/2016.
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
import SDWebImage


/// Chat Agent Image Cell
final class AgentImageCell: ImageChatCell, AgentCellType {
  
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
