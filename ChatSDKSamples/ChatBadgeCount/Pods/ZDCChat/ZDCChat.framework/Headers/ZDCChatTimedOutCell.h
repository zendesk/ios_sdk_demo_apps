/*
 *
 *  ZDCChatTimedOutCell.h
 *  ZDCChat
 *
 *  Created by Zendesk on 01/12/2014.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */


#import "ZDCChatCell.h"


/**
 * Cell for notifying that the chat has timed out.
 */
@interface ZDCChatTimedOutCell : ZDCChatCell


/**
 * Label displaying the chat message.
 */
@property (nonatomic, strong) UILabel *chatMessage;

/**
 * Insets of the text within the chat bubble.
 */
@property (nonatomic, strong) NSValue *textInsets UI_APPEARANCE_SELECTOR;

/**
 * Label text colour.
 */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

/**
 * Label font.
 */
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR;


@end

