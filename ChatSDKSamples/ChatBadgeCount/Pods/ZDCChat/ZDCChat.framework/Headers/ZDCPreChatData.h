/*
 *
 *  ZDCPreChatData.h
 *  ZDCChat
 *
 *  Created by Zendesk on 29/10/2014.
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

/**
 * Enum defining pre-chat chat data requirements.
 */
typedef NS_ENUM(NSUInteger, ZDCPreChatDataRequirement) {

    /// Data is not required.
    ZDCPreChatDataNotRequired               = 0,

    /// Data should be requested if not known but is not required.
    /// Once this data is known it will not be presented for editing by the user.
    ZDCPreChatDataOptional                  = 1,

    /// Data must be complete to start a chat.
    /// Once this data is known it will not be presented for editing by the user.
    ZDCPreChatDataRequired                  = 2,

    /// Data should be requested if not known but is not required.
    /// The user will be offered the opportunity to edit this data each time they start a chat.
    ZDCPreChatDataOptionalEditable          = 3,

    /// Data must be complete to start a chat.
    /// The user will be offered the opportunity to edit this data each time they start a chat.
    ZDCPreChatDataRequiredEditable          = 4
};


#pragma mark -

/**
 * Pre-chat data requirements.
 */
@interface ZDCPreChatData : NSObject

/**
 * Name field requirement.
 */
@property (nonatomic, assign) ZDCPreChatDataRequirement name;

/**
 * Email field requirement.
 */
@property (nonatomic, assign) ZDCPreChatDataRequirement email;

/**
 * Phone field requirement.
 */
@property (nonatomic, assign) ZDCPreChatDataRequirement phone;

/**
 * Department field requirement.
 */
@property (nonatomic, assign) ZDCPreChatDataRequirement department;

/**
 * Message field requirement.
 */
@property (nonatomic, assign) ZDCPreChatDataRequirement message;


@end
