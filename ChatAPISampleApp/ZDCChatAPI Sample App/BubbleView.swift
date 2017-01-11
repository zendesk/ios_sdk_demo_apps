/*
 *
 *  TextBubbleView.swift
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
import NSDate_TimeAgo


/// Bubble View State
enum BubbleState {
  
  /// Confirmed: happens when the message is confirmed
  case Confirmed
  
  /// Confirmed: the message is sent but not yet confirmed
  case NotConfirmed
  
  /// Confirmed: the bubble is an agent bubble
  case Hidden
  
  var image: UIImage {
    switch self {
    case .Confirmed:
      return UIImage(named: "check-mark")!
    case .Hidden:
      return UIImage()
    case .NotConfirmed:
      return UIImage(named: "refresh")!
    }
  }
}

/// Bubble View
@IBDesignable
final class BubbleView: UIView {
  
  enum CellType: String {
    case Agent = "agent", Visitor = "visitor"
  }
  
  @IBOutlet var contentView: UIView!
  private var timeStampLabel: UILabel!
  private var verifiedImage: UIImageView!
  
  @IBInspectable var typeString: String? {
    didSet {
      updateType()
    }
  }
  
  @IBInspectable var type: CellType = .Agent {
    didSet {
      let isAgent = type == .Agent
      
      verifiedImage?.hidden = isAgent
      backgroundColor = type.cellBackgroundColor
      timeStampLabel?.textColor = type.timestampTextColor
      additionalViewUpdate()
    }
  }
  
  var bubbleState: BubbleState = .Confirmed {
    didSet {
      verifiedImage.image = bubbleState.image
    }
  }
  
  var timestamp: NSDate = NSDate.init(timeIntervalSinceNow: -1000) {
    didSet {
      timeStampLabel.text = timestamp.dateTimeAgo()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = 4
    
    createViews()
    updateType()
  }
  
  func updateType() {
    if
      let typeString = typeString,
      let newType = CellType(rawValue: typeString) {
      type = newType
    }
  }
  
  //MARK: - Layout
  
  func createViews() {
    timeStampLabel = UILabel()
    timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
    timeStampLabel.font = UIFont.systemFontOfSize(11)
    timeStampLabel.text = "Some time ago"
    self.addSubview(timeStampLabel)
    
    verifiedImage = UIImageView(image: UIImage.init(named: "check-mark"))
    verifiedImage.contentMode = .ScaleAspectFit
    verifiedImage.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(verifiedImage)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    timeStampLabel.topAnchor.constraintEqualToAnchor(contentView.bottomAnchor, constant: 8).active = true
    timeStampLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -4).active = true
    timeStampLabel.setContentHuggingPriority(UILayoutPriorityRequired, forAxis: .Horizontal)
    timeStampLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
    
    verifiedImage.widthAnchor.constraintEqualToConstant(10).active = true
    verifiedImage.heightAnchor.constraintEqualToConstant(10).active = true
    verifiedImage.centerYAnchor.constraintEqualToAnchor(timeStampLabel.centerYAnchor, constant: 0).active = true
    
    verifiedImage.leadingAnchor.constraintEqualToAnchor(timeStampLabel.trailingAnchor, constant: 4).active = true
    
    if type == .Agent {
      timeStampLabel.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor).active = true
      trailingAnchor.constraintGreaterThanOrEqualToAnchor(verifiedImage.trailingAnchor, constant: 10).active = true
    } else {
      timeStampLabel.leadingAnchor.constraintGreaterThanOrEqualToAnchor(leadingAnchor, constant: 10).active = true
      trailingAnchor.constraintEqualToAnchor(verifiedImage.trailingAnchor, constant: 8).active = true
    }
  }
  
}

extension BubbleView {
  
  func additionalViewUpdate() {
    if let label = contentView as? UILabel {
      label.textColor = type.messageTextColor
    }
  }
  
}
