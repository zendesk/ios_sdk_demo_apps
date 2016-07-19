/*
 *
 *  ChatEventsProcessor.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 6/14/16.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zopim Chat SDK, You agree to the Zendesk Terms
 *  of Service https://www.zendesk.com/company/terms and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/application-developer-and-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Chat SDK.
 *
 */

import ZDCChatAPI


/**
 Chat UI Event Status
 
 - New:    The event received is a new event
 - Update: The event received is an update on a previous event
 - None:   The event received should be ignored
 */
enum ChatUIEventState {
  case New(ChatUIEvent)
  case Update(ChatUIEvent)
  case None
}

/**
 ChatEventsProcessor takes ZDCChatEvents emmited from the ChatAPI SDK and creates ChatEvent objects.
 - Filters unwanted events
 - Determins if an event is new or an update to a previous event
 */
final class ChatEventsProcessor {
  
  private var events: [String: ChatUIEvent]
  private var duplicateUpload: [String: String]
  
  init() {
    self.events = [:]
    self.duplicateUpload = [:]
  }
  
  /**
   Process a ZDCChatEvent.
   Filters unwanted events.
   Detemine if event is new or an update and call the appropriate callback
   
   - parameter event: ZDCChatEvent
   */
  func handleEvent(event: ZDCChatEvent) -> ChatUIEventState {
    guard let filteredEvent = filterEvents(event) else {
      return .None
    }
    
    let chatItem = filteredEvent.chatItem
    
    defer {
      self.events[chatItem.id] = chatItem
    }
    
    if events.keys.contains(chatItem.id) {
      return .Update(chatItem)
    } else {
      return .New(chatItem)
    }
  }
  
  /**
   Filter unwanted and duplicate events
   
   - parameter event: the event to filter
   
   - returns: the filtered event
   */
  private func filterEvents(event: ZDCChatEvent) -> ZDCChatEvent? {
    if (filterUnwantedEvents(event) == nil) {
      return nil
    }
    
    return filterDuplicateUploads(event)
  }
  
  /**
   Filter out unsupported events. As this project is intended to be a simple example only text and image attachemnts are supported
   
   - parameter event: ZDCChatEvent
   
   - returns: ZDCChatEvent if it is supported, else nil
   */
  private func filterUnwantedEvents(event: ZDCChatEvent) -> ZDCChatEvent? {
    if   event.type == .Unknown
      || event.type == .Rating
      || event.type == .RatingComment
      || event.type == .TriggerMessage
      || event.type == .SystemMessage
      || event.type == .MemberLeave
      || event.type == .MemberJoin {
      return nil
    }
    return event
  }
  
  //If a VisitorUpload with this id already exists, set new (duplicate) event ID to be the
  //same as the old one, effectifly turning it into an update.
  /**
   Filter duplicate uploas events. This is to compinsate for a Zopim returning upload competion event as a new event. If an event is not a duplicate return it, else set duplicate events ID to be the same as the original turning it into an update
   
   - parameter event: ZDCChatEvent
   
   - returns: Filtered ZDCChatEvent
   */
  private func filterDuplicateUploads(event: ZDCChatEvent) -> ZDCChatEvent! {
    //If a VisitorUpload with this id already exists, set new (duplicate) event ID to be the
    //same as the old one, effectifly turning it into an update.

    if event.type != .VisitorUpload {
      return event
    }
    
    if event.fileUpload == nil {
      return event
    }
    
    if let uid = duplicateUpload[event.fileUpload.uploadURL] {
      event.eventId = uid
    }
    
    duplicateUpload[event.fileUpload.uploadURL] = event.eventId
    return event
  }
  
}


