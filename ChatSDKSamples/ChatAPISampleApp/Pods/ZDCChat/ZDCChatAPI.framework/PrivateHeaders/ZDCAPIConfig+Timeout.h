/*
 *
 *  ZDCAPIConfig+Timeout.h
 *  ZDCChat
 *
 *  Created by Zendesk on 2/03/2016
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

#import "ZDCAPIConfig.h"


@interface ZDCAPIConfig ()

/**
 * Time interval to timeout a chat session when no message is sent from the visitor.
 *
 * Defaults to 300 seconds.
 * The maximum value allowed is 2700. If a bigger value is provided it will be cut of to the 2700
 */
@property (nonatomic, assign) NSTimeInterval sessionTimeoutInterval;

@end
