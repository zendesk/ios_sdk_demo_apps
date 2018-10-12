/*
 *
 *  ZDUImageRequestDelegate.h
 *  ZDCChat
 *
 *  Created by Zendesk on 02/06/2016.
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
 * Protocol defining the callback used when an image is ready.
 */
@protocol ZDUImageRequestDelegate <NSObject>

/**
 * Notify that an image has been retrieved, either from the cache or by download.
 */
- (void) imageDownloaded:(UIImage*)img;

@end
