/*
 *
 *  AgentImageView.swift
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


/// Agent Image view (Circular Image View)
final class AgentImageView: UIImageView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = frame.width / 2
    clipsToBounds = true
  }
  
}
