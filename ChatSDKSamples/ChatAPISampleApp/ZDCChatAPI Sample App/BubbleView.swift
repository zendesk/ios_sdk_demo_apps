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
import DateToolsSwift


/// Bubble View State
enum BubbleState {
  
  /// Confirmed: happens when the message is confirmed
  case confirmed
  
  /// Confirmed: the message is sent but not yet confirmed
  case notConfirmed
  
  /// Confirmed: the bubble is an agent bubble
  case hidden
  
  var image: UIImage {
    var imageName: String = ""
    switch self {
    case .confirmed:
      imageName = "check-mark"
    case .notConfirmed:
      imageName = "refresh"
    default:
      break
    }

    return UIImage(named: imageName)!
  }
}

/// Bubble View
@IBDesignable
final class BubbleView: UIView {
  
  enum CellType: String {
    case Agent = "agent", Visitor = "visitor"
  }
  
  @IBOutlet var contentView: UIView!
  fileprivate var timeStampLabel: UILabel!
  fileprivate var verifiedImage: UIImageView!
  
  @IBInspectable var typeString: String? {
    didSet {
      updateType()
    }
  }
  
  var type: CellType = .Agent {
    didSet {
      let isAgent = type == .Agent
      
      verifiedImage?.isHidden = isAgent
      backgroundColor = type.cellBackgroundColor
      timeStampLabel?.textColor = type.timestampTextColor
      additionalViewUpdate()
    }
  }
  
  var bubbleState: BubbleState = .confirmed {
    didSet {
      verifiedImage.image = bubbleState.image
    }
  }
  
  var timestamp: Date = Date.init(timeIntervalSinceNow: -1000) {
    didSet {
      timeStampLabel.text = timestamp.timeAgoSinceNow
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
    timeStampLabel.font = UIFont.systemFont(ofSize: 11)
    timeStampLabel.text = "Some time ago"
    self.addSubview(timeStampLabel)
    
    verifiedImage = UIImageView(image: BubbleState.confirmed.image)
    verifiedImage.contentMode = .scaleAspectFit
    verifiedImage.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(verifiedImage)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    timeStampLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8).isActive = true
    timeStampLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
    timeStampLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    timeStampLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
    
    verifiedImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
    verifiedImage.heightAnchor.constraint(equalToConstant: 10).isActive = true
    verifiedImage.centerYAnchor.constraint(equalTo: timeStampLabel.centerYAnchor, constant: 0).isActive = true
    
    verifiedImage.leadingAnchor.constraint(equalTo: timeStampLabel.trailingAnchor, constant: 4).isActive = true
    
    if type == .Agent {
      timeStampLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
      trailingAnchor.constraint(greaterThanOrEqualTo: verifiedImage.trailingAnchor, constant: 10).isActive = true
    } else {
      timeStampLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10).isActive = true
      trailingAnchor.constraint(equalTo: verifiedImage.trailingAnchor, constant: 8).isActive = true
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
