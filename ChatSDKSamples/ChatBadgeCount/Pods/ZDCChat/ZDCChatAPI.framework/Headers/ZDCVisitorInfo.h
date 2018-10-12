/*
 *
 *  ZDCVisitorInfo.h
 *  ZDCChat
 *
 *  Created by Zendesk on 27/11/2014.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */


#import <Foundation/Foundation.h>


@protocol ZDCChatIO;
/**
 * The visitor details currently known by the Chat SDK.
 * The values here are never read from the server, they are only used to send information.
 */
@interface ZDCVisitorInfo : NSObject


/**
 * The visitors name to be submitted prior to the chat starting.
 */
@property (nonatomic, strong) NSString *name;

/**
 * The visitors email to be submitted prior to the chat starting.
 */
@property (nonatomic, strong) NSString *email;

/**
 * The visitors phone to be submitted prior to the chat starting.
 */
@property (nonatomic, strong) NSString *phone;

/*
 * Add a visitor note. This will append it to any existing notes in Zopim.
 * @param the note to set
 */
- (void) addNote:(NSString*)note;



/**
 * Specifies whether visitor data should be persisted for use when starting 
 * future chat sessions. If switched off then persisted data will immediately be wiped.
 */
@property (nonatomic, assign) BOOL shouldPersist;


/**
 * New instance initialised with the provided chat IO.
 * @param chatIO the chat IO for sending updates
 */
- (instancetype) initWithIO:(id<ZDCChatIO>)chatIO;


@end

