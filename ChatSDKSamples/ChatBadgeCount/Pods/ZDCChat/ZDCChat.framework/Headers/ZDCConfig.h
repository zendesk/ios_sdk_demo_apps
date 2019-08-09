/*
 *
 *  ZDCConfig.h
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

#if MODULES_DISABLED
#import <ZDCChatAPI/ZDCChatAPI.h>
#else
@import ZDCChatAPI;
#endif
#import "ZDCPreChatData.h"


@interface ZDCConfig : NSObject

/**
 * This string will be placed in the first line of the visitor path and is equivalent to the 'referrer'.
 * Defaults to the form: "{app_name}, v{app_version}({build_number})"
 * Must be set before a connection is created if a custom string is required.
 */
@property (nonatomic, strong) NSString *visitorPathOne;

/**
 * This string will be placed in the second line of the visitor path and is equivalent to the 'title'.
 * Defaults to the form: "{app_name}"
 * Must be set before a connection is created if a custom string is required.
 */
@property (nonatomic, strong) NSString *visitorPathTwo;

/**
 * The department to be selected when a chat starts.
 */
@property (nonatomic, strong) NSString *department;

/**
 * The tags to be set when a chat starts.
 */
@property (nonatomic, strong) NSArray<NSString *> *tags;

/**
 * Pre-chat data requirements.
 */
@property (nonatomic, strong) ZDCPreChatData *preChatDataRequirements;

/**
 *  Set wehter upload attachments is enabled or not.
 *  - When set to YES, attachment button will be visible in the chat
 *    viewcontroller (button visibility depends on the account plan not being lite/free)
 *  - When set to NO, attachment button will not be visible in the chat viewcontroller
 */
@property (nonatomic, assign) BOOL uploadAttachmentsEnabled;

/**
 *  Email transcript action, defaults to ZDCEmailTranscriptActionPrompt.
 */
@property (nonatomic, assign) ZDCEmailTranscriptAction emailTranscriptAction;

/**
 * Timeout applied on initial chat startup; if the session does not achieve a connection in this
 * time then the connection attempt is considered to have failed (default 30 seconds).
 */
@property (nonatomic, assign) NSTimeInterval connectionTimeout;

/**
 * Timeout applied when reconnecting to an existing active chat, if the session does not achieve a
 * connection in this time then the connection attempt is considered to have failed and the user is
 * asked if they want to continue or not (default 120 seconds).
 */
@property (nonatomic, assign) NSTimeInterval reconnectionTimeout;

/**
 * If YES, connection bar will be shown to inform user when connection status change. Defaults to YES.
 */
@property (nonatomic, assign) BOOL showsConnectionBar;

/**
 * Defaults to 0 seconds. When 0 seconds is specified, connection bar will stay persistent. If non-zero interval is provided, the connection bar will auto-close after defined timeout
 */
@property (nonatomic, assign) NSTimeInterval connectionBarAutoCloseDuration;

@end
