/*
 *
 *  ZDCChatAPIEnums.h
 *  ZDCChat
 *
 *  Created by Zendesk on 13/14/2015.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

/**
 * Chat ratings.
 */
typedef NS_ENUM(NSUInteger, ZDCChatRating) {
    
    /// Not yet rated.
    ZDCChatRatingUnrated    = 0,
    
    /// No rating.
    ZDCChatRatingNone       = 1,
    
    /// Good chat rating.
    ZDCChatRatingGood       = 2,
    
    /// Bad chat rating.
    ZDCChatRatingBad        = 3
};

typedef NS_ENUM(NSUInteger, ZDCChatSessionStatus) {
    
    /// There is no active chat session
    ZDCChatSessionStatusInactive          = 0,
    
    /// A session has been started but no messages have been sent
    ZDCChatSessionStatusConnected         = 1,
    
    /// A session has been started and a message has been sent by the visitor
    ZDCChatSessionStatusChatting          = 2,
    
    /// The active session has timed out and should be ended
    ZDCChatSessionStatusTimedOut          = 3
};

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

/**
 * Chat connection status.
 */
typedef NS_ENUM(NSUInteger, ZDCConnectionStatus) {
    
    /// Chat connection has not been started.
    ZDCConnectionStatusUninitialized     = 0,
    
    /// Chat is currently establishing a connection.
    ZDCConnectionStatusConnecting        = 1,
    
    /// Chat is connected.
    ZDCConnectionStatusConnected         = 2,
    
    /// Chat connection has been closed.
    ZDCConnectionStatusClosed            = 3,
    
    /// Chat connection lost.
    ZDCConnectionStatusDisconnected      = 4,
    
    /// Device has no internet connection.
    ZDCConnectionStatusNoConnection      = 5
};


#pragma mark notifications

extern NSString * const ZDC_CHAT_UI_DID_LOAD;

extern NSString * const ZDC_CHAT_UI_DID_LAYOUT;

extern NSString * const ZDC_CHAT_UI_WILL_UNLOAD;

extern NSString * const ZDC_NOTIFICATION_FILE_UPLOAD;
