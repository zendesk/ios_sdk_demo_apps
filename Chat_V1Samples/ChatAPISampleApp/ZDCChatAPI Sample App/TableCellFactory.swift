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
                                         indexPath: IndexPath,
                                         event: ChatUIEvent) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: event.type.tableIdentifier, for: indexPath)
    
    if var chatCell = cell as? ChatCellType {
      chatCell.chatEvent = event
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
enum EventType: String {
  case agentMessage, agentImage, visitorMessage, visitorImage
}

extension EventType {
  var tableIdentifier: String {
    switch self {
    case .agentMessage:
      return "agentCell"
    case .visitorMessage:
      return "visitorCell"
    case .visitorImage:
      return "visitorImageCell"
    case .agentImage:
      return "agentImageCell"
    }
  }
}
