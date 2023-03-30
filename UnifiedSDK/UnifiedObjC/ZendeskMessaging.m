/*
 *
 *  ZendeskMessaging.m
 *  UnifiedObjC
 *
 *  Created by Zendesk on 22/09/2020.
 *
 *  Copyright © 2020 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

#import <Foundation/Foundation.h>

#import <MessagingSDK/MessagingSDK.h>
#import <MessagingAPI/MessagingAPI.h>
#import <CommonUISDK/CommonUISDK.h>

#import <ChatSDK/ChatSDK.h>
#import <ChatProvidersSDK/ChatProvidersSDK.h>

@interface ZendeskMessaging : NSObject

+ (void) init;
+ (UIViewController *) buildUI;

@end

@implementation ZendeskMessaging


+ (void) init {

    [ZendeskMessaging setChatLogging:YES withLogLevel:ZDKChatLogLevelVerbose];
    #warning("Please provide Chat account key")
    [ZDKChat initializeWithAccountKey:@"<#NSString#>" queue: dispatch_get_main_queue()];
    // [[ZDKCommonTheme currentTheme] setPrimaryColor: UIColor.greenColor];
}

+ (void) setChatLogging:(BOOL)isEnabled withLogLevel:(ZDKChatLogLevel)logLevel {
    [ZDKChatLogger setIsEnabled: isEnabled];
    [ZDKChatLogger setDefaultLevel: logLevel];
}

+ (ZDKClassicMessagingConfiguration *) messagingConfiguration {
    ZDKClassicMessagingConfiguration *config = [ZDKClassicMessagingConfiguration new];
    config.name = @"Chat Bot";
    config.isMultilineResponseOptionsEnabled = YES;
    return config;
}

+ (ZDKChatConfiguration *) chatConfiguration {
    ZDKChatConfiguration *config = [ZDKChatConfiguration new];
    config.isAgentAvailabilityEnabled = NO;
    config.isPreChatFormEnabled = YES;
    return config;
}

+ (ZDKChatAPIConfiguration *) chatAPIConfiguration {
    ZDKChatAPIConfiguration *config = [ZDKChatAPIConfiguration new];
    config.tags = @[@"iOS", @"chat_v2"];
    return config;
}

+ (UIViewController *) buildUI {
    [[ZDKChat instance] setConfiguration: [self chatAPIConfiguration]];
    NSError *error = nil;
    NSArray *engines = @[
         (id <ZDKEngine>) [ZDKChatEngine engineAndReturnError: &error]
     ];

    NSArray<id<ZDKConfiguration>> *configs = @[[self messagingConfiguration], [self chatConfiguration]];

    return [[ZDKClassicMessaging instance] buildUIWithEngines: engines configs:configs error: &error];
}

@end
