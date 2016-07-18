/*
 *
 *  AgentImageView.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 08/07/2016.
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


/// Agent Image view (Circular Image View)
final class AgentImageView: UIImageView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = frame.width / 2
    clipsToBounds = true
  }
  
}
