/*
 *
 *  ZDCOfflineMessageHandler.h
 *  ZDCChat
 *
 *  Created by Zendesk on 06/03/2015.
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
 * Class defining an override of the default offline message handling.
 */
@interface ZDCOfflineMessageHandler : NSObject


/**
 * When there are no agents online the visitor is presented with an error/info screen with the default 
 * title 'No agents available' ("ios.ZDCChat.noAgentsTitle"). This string defines the message body 
 * which is presented below that title and above the message creation button. If this is left nil 
 * then the default string ("ios.ZDCChat.noAgentsMessage") will be used.
 */
@property (nonatomic, strong) NSString *noAgentsMessage;

/**
 * When there are no agents online the visitor is presented with an error/info screen with the default
 * title 'No agents available' ("ios.ZDCChat.noAgentsTitle"). This string button text for the message 
 * creation button. If this is left nil then the default string ("ios.ZDCChat.noAgentsButton") will be used.
 */
@property (nonatomic, strong) NSString *noAgentsButtonText;

/**
 * Create a new offline message override with the defined parameters.
 * @param noAgentsMessage the message body on the 'No agents available' screen
 * @param noAgentsButtonText button text on the 'No agents available' screen
 */
+ (instancetype) offlineHandlerWithMessage:(NSString*)noAgentsMessage
                                buttonText:(NSString*)noAgentsButtonText;


@end
