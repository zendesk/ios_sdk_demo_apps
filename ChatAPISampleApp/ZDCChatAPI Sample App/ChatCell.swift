/*
 *
 *  ChatCell.swift
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


/// Chat General Cell
class ChatCell: UITableViewCell{
  
  /// Bubble view
  @IBOutlet var bubbleView: BubbleView!
  
  /// List of chat events received
  var chatEvent: ChatUIEvent! {
    didSet {
      bubbleState = chatEvent.confirmed ? .Confirmed : .NotConfirmed
      bubbleView.timestamp = chatEvent.timeStamp
    }
  }
  
}


extension ChatCell: ChatCellType {
  
  var bubbleState: BubbleState {
    get {
      return bubbleView.bubbleState
    }
    
    set {
      bubbleView.bubbleState = newValue
    }
  }
}

//MARK: - Message Cell

/// Chat Message General Cell
class MessageChatCell: ChatCell {
  
  @IBOutlet var messageLabel: UILabel!
  
  override var chatEvent: ChatUIEvent! {
    didSet {
      super.chatEvent = chatEvent
      if let chatTextCell = chatEvent as? ChatMessageEventType {
        textContent = chatTextCell.text
      }
    }
  }
}

extension MessageChatCell: TextCellType {
  
  var textContent: String? {
    set {
      self.messageLabel.text = newValue
    }
    
    get {
      return self.messageLabel.text
    }
  }
}

//MARK: - Image Cell

/// Chat Image General Cell
class ImageChatCell: ChatCell {
  
  @IBOutlet var imageContentView: UIImageView!
  @IBOutlet var heightConstraint: NSLayoutConstraint!
  
  override var chatEvent: ChatUIEvent! {
    didSet {
      super.chatEvent = chatEvent
      
      if let chatImageCell = chatEvent as? ChatImageEventType {
        if let image = chatImageCell.image {
          imageContent = image
        }
        if let url = chatImageCell.imageURL {
          setImageURL(url)
        }
      }
    }
  }
}

extension ImageChatCell: ImageCellType {
  var imageContent: UIImage? {
    set {
      self.imageContentView.image = newValue
      updateHeight()
    }
    
    get {
      return self.imageContentView.image
    }
  }
  
  func setImageURL(url: NSURL?) {
    self.imageContentView.sd_setImageWithURL(url)
    
    self.imageContentView.contentMode = .Center
    setPlaceholderHeight()
    
    self.imageContentView.image = UIImage(named: "placeholder")
    self.imageContentView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "placeholder"))
    { (image, error, cache, url) in
      
      if image != nil {
        self.imageContentView.contentMode = .ScaleAspectFit
        self.updateHeight()
      }
    }
  }
  
  override func prepareForReuse() {
    self.imageContentView.sd_cancelCurrentImageLoad()
  }
  
  func updateHeight() {
    guard let size = imageContentView.image?.size else { return }
    guard let viewWidth = imageContentView.superview?.frame.width else { return }
    
    let height = (size.height * viewWidth) / size.width
    self.heightConstraint.constant = height
  }
  
  func setPlaceholderHeight() {
    guard let viewWidth = imageContentView.superview?.frame.width else { return }
    
    self.heightConstraint.constant = viewWidth
  }
}
