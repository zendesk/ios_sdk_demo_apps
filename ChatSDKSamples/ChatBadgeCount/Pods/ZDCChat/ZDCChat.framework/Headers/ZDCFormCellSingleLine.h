/*
 *
 *  ZDCFormCellSingleLine.h
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
 * Single line text entry cell for pre chat form fields which presents rows for name,
 * email and phone.
 */
@interface ZDCFormCellSingleLine : ZDCFormCell <UITextFieldDelegate>


/**
 * The text field providing text entry.
 */
@property (nonatomic, strong) UITextField *textField;


@end

