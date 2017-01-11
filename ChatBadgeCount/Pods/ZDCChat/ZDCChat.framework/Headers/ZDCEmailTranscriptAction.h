/*
 *
 *  ZDCEmailTranscriptAction.h
 *  ZDCChat
 *
 *  Created by Zendesk on 13/14/2015.
 *
 *  Copyright (c) 2015 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

/**
 *  Enum the defines the action to take with email transcripts
 */
typedef NS_ENUM(NSUInteger, ZDCEmailTranscriptAction) {
  /**
   *  Always prompt the user for a decision on wether he wants to send the transcript or not.
   */
  ZDCEmailTranscriptActionPrompt = 0,
  /**
   *  Never prompt the user about sending the email transcript
   */
  ZDCEmailTranscriptActionNeverSend = 1,
};