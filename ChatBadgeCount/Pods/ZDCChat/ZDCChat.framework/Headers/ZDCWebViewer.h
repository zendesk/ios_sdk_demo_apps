/*
 *
 *  ZDCWebViewer.h
 *  ZDCChat
 *
 *  Created by Zendesk on 05/11/2014.
 *
 *  Copyright (c) 2015 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */


#import <UIKit/UIKit.h>

/**
 * View controller containing a single webview for viewing non-image files sent as attachments.
 */
@interface ZDCWebViewer : UIViewController <UIWebViewDelegate>


/**
 * The url to be viewed
 */
@property (nonatomic, strong) NSString *url;

/**
 * The webview presenting the file.
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 * Loading indicator.
 */
@property (nonatomic, strong) UIActivityIndicatorView *spinner;


/**
 * New instance.
 * @param the url string for the resource to be viewed
 */
- (instancetype) initWithURL:(NSString*)url;


@end

