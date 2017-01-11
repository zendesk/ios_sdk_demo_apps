/*
 *
 *  ZDCSessionConfig.h
 *  ZDCChat
 *
 *  Created by Zendesk on 27/11/2014.
 *
 *  Copyright (c) 2015 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */


#import <Foundation/Foundation.h>
#import "ZDCPreChatData.h"
#import "ZDCChatIO.h"
#import "ZDCEmailTranscriptAction.h"


/**
 * The session config defines a one off session requirements for a chat.
 */
@interface ZDCSessionConfig : NSObject


/**
 * Pre-chat data requirements.
 */
@property (nonatomic, strong) ZDCPreChatData *preChatDataRequirements;

/**
 * The department to be selected when a chat starts.
 */
@property (nonatomic, strong) NSString *department;

/**
 * The tags to be set when a chat starts.
 */
@property (nonatomic, strong) NSArray *tags;

/**
 *  Email transcript action, defaults to ZDCEmailTranscriptActionPrompt.
 */
@property (nonatomic, assign) ZDCEmailTranscriptAction emailTranscriptAction;

/**
 * New instance initialised with the provided chat IO.
 * @param chatIO the chat IO for sending updates
 */
- (instancetype) initWithIO:(id<ZDCChatIO>)chatIO;


@end

