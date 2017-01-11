/*
 *
 *  TableCellFactory.swift
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


/// Table Cell Factory
final class TableCellFactory {
  
  /**
   Create a UITableViewCell view
   
   - parameter tableView: tableview
   - parameter indexPath: the index path
   - parameter event:     the chat event to create a cell for
   
   - returns: a UITableViewCell instance
   */
  static func constructCell(forTableView tableView: UITableView,
                                         indexPath: NSIndexPath,
                                         event: ChatUIEvent) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(event.type.tableIdentifier, forIndexPath: indexPath)
    
    if var th = cell as? ChatCellType {
      th.chatEvent = event
    }
    
    return cell
  }
}

/**
 Event Type Enum
 
 - AgentMessage:   agent text message event
 - AgentImage:     agent image message event
 - VisitorMessage: visitor text message event
 - VisitorImage:   visitor image message event
 */
enum EventType {
  case AgentMessage, AgentImage, VisitorMessage, VisitorImage
}

extension EventType {
  var tableIdentifier: String {
    switch self {
    case AgentMessage:
      return "agentCell"
    case VisitorMessage:
      return "visitorCell"
    case VisitorImage:
      return "visitorImageCell"
    case AgentImage:
      return "agentImageCell"
    }
  }
}