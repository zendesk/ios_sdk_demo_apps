/*
 *
 *  ZDCChatAvatar.h
 *  ZDCChat
 *
 *  Created by Zendesk on 02/12/2014.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */


#import "ZDUExternalImage.h"


/**
 * Chat avatar used by chat table cells.
 */
@interface ZDCChatAvatar : ZDUExternalImage

/**
 *  Setting the default avatar to an image
 *
 */
@property (nonatomic, strong) UIImage *defaultAvatarImage UI_APPEARANCE_SELECTOR;

@end
