//
//  CellBuilder.swift
//  ZDCChatAPI Sample App
//
//  Created by Steven Diviney on 7/11/16.
//  Copyright © 2016 Omar Abdelhafith. All rights reserved.
//

import UIKit

class CellBuilder {
  
  func cellFromItem(chatItem: ChatItemProtocol, tableView: UITableView) -> UITableViewCell? {
    
    
    if chatItem.type == TextMessageModel.chatItemType {
      return textCellFromItem(chatItem, tableView: tableView)
    }
    
    if chatItem.type == PhotoMessageModel.chatItemType {
      return imageCellFromItem(chatItem, tableView: tableView)
    }
    
    return nil
    
  }
  
  func textCellFromItem(chatItem: ChatItemProtocol, tableView: UITableView) -> UITableViewCell{
    guard let textMessage = chatItem as? TextMessageModel else {
      assert(false, "Expecting text message cell")
    }
    
    var cell: MessageChatCell!
    
    if textMessage.messageModel.isIncoming {
      cell = tableView.dequeueReusableCellWithIdentifier(CellType.AgentMessage.rawValue) as! AgentMessageCell
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier(CellType.VisitorMessage.rawValue) as! VisitorMessageCell
      cell.bubbleState = self.messageStatusToBubbleState(textMessage.messageModel.status)
    }
    
    cell.textContent = textMessage.text
    cell.bubbleView.timeStamp.text = self.dateToString(textMessage.messageModel.timestamp)
    
    return cell
  }
  
  func imageCellFromItem(chatItem: ChatItemProtocol, tableView: UITableView) -> UITableViewCell {
    guard let imageMessage = chatItem as? PhotoMessageModel else {
      assert(false, "Expecting image message cell")
    }
    
    var cell: ImageChatCell!
    
    if imageMessage.messageModel.isIncoming {
      cell = tableView.dequeueReusableCellWithIdentifier(CellType.AgentImage.rawValue) as! AgentImageCell
      cell.setImageURL(imageMessage.url)
    } else {
      cell = tableView.dequeueReusableCellWithIdentifier(CellType.VisitorImage.rawValue) as! VisitorImageCell
      cell.imageContent = imageMessage.image
      cell.bubbleState = self.messageStatusToBubbleState(imageMessage.messageModel.status)
    }
    
    cell.bubbleView.timeStamp.text = self.dateToString(imageMessage.messageModel.timestamp)
    
    return cell
  }
  
  func dateToString(date: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    return dateFormatter.stringFromDate(date)
  }
  
  func messageStatusToBubbleState(messageStatus: MessageStatus) -> BubbleState{
    if messageStatus == MessageStatus.Success {
      return BubbleState.Confirmed
    }
    
    if messageStatus == MessageStatus.Sending {
      return BubbleState.NotConfirmed
    }
    
    //Need a proper failure state
    return BubbleState.Hidden
  }

}
  
  



