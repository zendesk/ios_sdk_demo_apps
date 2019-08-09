/*
 *
 *  ZDChatViewController.h
 *  ZDCChat
 *
 *  Created by Zendesk on 24/09/2014.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */


#import "ZDUViewController.h"
#import "ZDCChatUI.h"


/**
 * View controller containing the complete chat UI.
 */
@interface ZDCChatViewController : ZDUViewController <ZDCChatUIController, ZDCInsetProvider>


/**
 * The chat UI including loading screen and pre-chat form.
 */
@property (nonatomic, strong) ZDCChatUI *chatUI;

@property (nonatomic, assign) BOOL showsConnectionBar;

@property (nonatomic, assign) NSTimeInterval connectionBarAutocloseDuration;


@end

