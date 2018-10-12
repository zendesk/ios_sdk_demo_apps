/*
 *
 *  ZDCFormCellMessage.h
 *  ZDCChat
 *
 *  Created by Zendesk on 29/01/2015.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */


#import "ZDCFormCell.h"


/**
 * Cell for presenting the pre-chat form message editor.
 */
@interface ZDCFormCellMessage : ZDCFormCell <UITextViewDelegate>


/**
 * The text field providing text entry.
 */
@property (nonatomic, strong) ZDUTextView *textView;


@end

