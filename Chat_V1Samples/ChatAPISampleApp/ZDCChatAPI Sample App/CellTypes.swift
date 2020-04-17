/*
 *
 *  TextCell.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 07/07/2016.
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
 Protocol that represents a generic chat cell type
 */
protocol ChatCellType {
  /// The bubble state
  var bubbleState: BubbleState { get set }
  
  /// The chat event linked to this cell
  var chatEvent: ChatUIEvent! { get set }
}

/**
 Protocol that represents a textual chat cell type
 */
protocol TextCellType: ChatCellType {
  
  /// The text content linekd to this cell
  var textContent: String? { get set }
}

/**
 Protocol that represents a image chat cell type
 */
protocol ImageCellType: ChatCellType {
  
  /// the image content linked to this cell
  var imageContent: UIImage? { get set }
  
  /**
   Sets the image URL to display in the cell
   
   - parameter url: The image url to display
   */
  func setImageURL(_ url: URL?)
}

/**
 Protocol that represents an agent chat cell type
 */
protocol AgentCellType: ChatCellType {
  
  /// The agent thumbnail image
  var agentImage: UIImageView! { get }
  
  /**
   Sets the agent avatar URL to display in the cell
   
   - parameter url: The avatar url to display
   */
  func setAgentAvatar(_ url: URL?)
}

//MARK: - Extensions

extension AgentCellType {
  
  func setAgentAvatar(_ url: URL?) {
    
    self.agentImage.contentMode = .scaleAspectFit
    self.agentImage.backgroundColor = agentBackgroundColor
    self.agentImage.sd_setImage(with: url, placeholderImage: UIImage(named: "user"))
    
  }
}
