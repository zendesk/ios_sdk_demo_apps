/*
 *
 *  ZDCAPIConfig.h
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


/**
 * The session config defines a one off session requirements for a chat.
 */
@interface ZDCAPIConfig : NSObject


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
 * This is the URL for the visitor path on line 2 of the visitor path.
 * Defaults to the form: "{app_name}://{long timestamp}"
 */
@property (nonatomic, strong) NSString *visitorPathTwoUrl;

/**
 * The department to be selected when a chat starts.
 */
@property (nonatomic, strong) NSString *department;

/**
 * The tags to be set when a chat starts.
 */
@property (nonatomic, strong) NSArray *tags;


@end

