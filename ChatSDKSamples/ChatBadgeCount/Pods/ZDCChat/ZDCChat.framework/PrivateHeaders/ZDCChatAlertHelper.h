/*
 *
 *  ZDCChatAlertHelper.h
 *  ZDCChat
 *
 *  Created by Zendesk on 08/12/2015.
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
@class ZDCChatUI;


@protocol ZDCChatAlertHelperDelegate <NSObject>

- (BOOL)isValidChatSessionWithoutErrors;
- (BOOL)isSendingChatTranscriptEnabled;
- (BOOL)isChatLogEmpty;

- (void)disableChatEntryTextView;

- (NSString*)storedEmailTranscriptDestination;
- (void)sendTranscriptToEmail:(NSString*)email;

- (void)endChat;

@end

@interface ZDCChatAlertHelper : NSObject

- (instancetype)initWithDelegate:(id<ZDCChatAlertHelperDelegate>)delegate;
- (BOOL)shouldShowEndChatEmail;
- (void)showEndChatAlert;

@end
