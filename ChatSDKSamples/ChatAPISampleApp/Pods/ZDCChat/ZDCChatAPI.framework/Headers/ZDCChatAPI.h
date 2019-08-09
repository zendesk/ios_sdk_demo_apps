/*
 *
 *  ZDCChatAPI.h
 *  ZDCChat
 *
 *  Created by Zendesk on 07/06/2016.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

#import <UIKit/UIKit.h>

// Chat API SDK Version
#define ZDC_CHAT_API_SDK_VERSION @"1.4.1"

#import <SystemConfiguration/SystemConfiguration.h>

#import "ZDCChatAPIEnums.h"
#import "ZDCAPIConfig.h"

#import "ZDCLog.h"
#import "ZDCChatEvent.h"
#import "ZDCChatAgent.h"
#import "ZDCChatAttachment.h"
#import "ZDCChatUpload.h"
#import "ZDCVisitorInfo.h"
#import "ZDCChatProfile.h"


@interface ZDCChatAPI : NSObject

/**
 * Visitor info;
 */
@property (nonatomic, strong) ZDCVisitorInfo *visitorInfo;

/**
 * Get the current vistors (user) profile object.
 * @return the profile object
 */
@property (nonatomic, strong, readonly) ZDCChatProfile *profile;

/**
 * Get an array of all the chat events received.
 * @return an ordered array of ZDCChatEvent objects
 */
@property (nonatomic, strong, readonly) NSArray<ZDCChatEvent*> *livechatLog;

/**
 * Get the department list for this account.
 * @return the list of department names as NSString objects, if any
 */
@property (nonatomic, strong, readonly) NSArray<NSString*> *departments;

/**
 * Get list of agents on this conversation.
 * @return the dictionary of agents with nickname as key.
 */
@property (nonatomic, strong, readonly) NSDictionary<NSString*, ZDCChatAgent*> *agents;

/**
 * Get the number of messages sent by the agent.
 * @return the number of agent messages received.
 */
@property (nonatomic, assign, readonly) NSInteger agentMessageCount;

/**
 * Check if the account is online and available for chat.
 * Account is online when there is one or more agents available to chat
 *
 * @return YES if the account is online.
 */
@property (nonatomic, assign, readonly) BOOL isAccountOnline;

/**
 * Is file sending enabled. If enabled the user will be able to send images as attachments.
 */
@property (nonatomic, assign, readonly) BOOL fileSendingEnabled;

/**
 * Get the current chat session status.
 * @return status the current session status
 */
@property (nonatomic, assign, readonly) ZDCChatSessionStatus chatStatus;


/**
 * Get the current connection status.
 * @return chat connection status
 */
@property (nonatomic, assign, readonly) ZDCConnectionStatus connectionStatus;

/**
 * Check if there is an offline message still pending.
 * @return YES if the message has not yet been confirmed
 */
@property (nonatomic, assign, readonly) BOOL offlineMessagePending;

/**
 * Account key used for connection
 * @return account key
 */
@property (nonatomic, strong, readonly) NSString *accountKey;

/**
 Get the chat interface singleton
 */
+ (instancetype)instance;

/**
 Start a chat session
 
 @param accountKey account key to use for connection
 */
- (void)startChatWithAccountKey:(NSString*)accountKey;

/**
 Start a chat session
 
 @param accountKey account key to use for connection
 @param config api session configurations to use
 */
- (void)startChatWithAccountKey:(NSString*)accountKey
                         config:(ZDCAPIConfig*)config;

/**
 * End the current chat session
 */
- (void)endChat;

/**
 Unavialable initializers
 */
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end



/**
 Category containing messaging related methods
 */
@interface ZDCChatAPI (Messaging)

/**
 * Send a chat message from this visitor to the server
 * @param message the chat message
 */
- (void)sendChatMessage:(NSString*)message;

/**
 * Send an offline message.
 * @param message the message to be sent.
 */
- (void)sendOfflineMessage:(NSString*)message;

/**
 * Resend the provided chat event (which contains the message).
 * @param event the chat event to be resent
 */
- (void)resendChatMessage:(ZDCChatEvent*)event;

/**
 * Emails the transcript to the provided email
 * @param email the email to send the transcript to.
 */
- (void)emailTranscript:(NSString*)email;

/**
 * Send a chat rating response.
 * @param rating the selected rating response
 */
- (void)sendChatRating:(ZDCChatRating)rating;

/**
 * Send a chat rating comment.
 * @param comment the rating comment
 */
- (void)sendChatRatingComment:(NSString*)comment;

/**
 * Upload the file with the provided url to the server.
 * @param path path to the file on the local filesystem
 * @param fileName name with which to upload the file, must include it's extension
 */
- (void)uploadFileWithPath:(NSString*)path name:(NSString*)fileName;

/**
 * Upload the file with the provided data to the server.
 * @param data the file data
 * @param fileName name with which to upload the file, must include it's extension
 */
- (void)uploadFileWithData:(NSData*)data name:(NSString*)fileName;

/**
 * Upload the the provided image to the server.
 * @param image the image to be uploaded
 * @param fileName name with which to upload the file, must include it's extension
 */
- (void)uploadImage:(UIImage*)image name:(NSString*)fileName;

/**
 * Set a visitor note. This will replace anything set by the agent.
 * @param the note text
 */
- (void) setNote:(NSString*)note;

/**
 * Append a visitor note
 * @param the note text
 */
- (void) appendNote:(NSString*)note;

/**
 * Set the push token for this session.
 *
 * @param token the push token received from the didRegisterForRemoteNotificationsWithDeviceToken response
 */
- (void) setPushToken:(NSData*)token;

/**
 * If a user revokes push permissions you can remove the push token from the session with this method.
 */
- (void) clearPushToken;


@end


/**
 Category containing events methods
 */
@interface ZDCChatAPI (Events)

/**
 * Add observer to listen to time out events.
 * When this notification is posted it means that the chat session has timed out
 * Observer must be removed before deallocation.
 *
 * @param target the listener to add
 * @param selector the selector to be invoked on the target
 */
- (void)addObserver:(id)target forTimeoutEvents:(SEL)selector;

/**
 * Remove timeout observers for the target.
 * @param target the listener to remove
 */
- (void)removeObserverForTimeoutEvents:(id)target;

/**
 * Listen for chat connection events.
 * The chat connection status is read from `[ZDCChatAPI instance].connectionStatus`
 * Observer must be removed before deallocation.
 *
 * @param target the listener to add
 * @param selector the selector to be invoked on the target
 */
- (void)addObserver:(id)target forConnectionEvents:(SEL)selector;

/**
 * Remove chat connection observers for the target.
 * @param target the listener to remove
 */
- (void)removeObserverForConnectionEvents:(id)target;

/**
 * Listen for chat events.
 * Inside the handler method, call `[[ZDCChat instance].api livechatLog];` to get the updated list of log events.
 * Observer must be removed before deallocation.
 *
 * @param target the listener to add
 * @param selector the selector to be invoked on the target
 */
- (void)addObserver:(id)target forChatLogEvents:(SEL)selector;

/**
 * Remove chat log observers for the target.
 * @param target the listener to remove
 */
- (void)removeObserverForChatLogEvents:(id)target;

/**
 * Listen for agent events. Agent events include agent details and agent typing status.
 * Inside the handler you can check the updated list of agents with `[[ZDCChat instance].api agents]`
 * `[[ZDCChat instance].api agents]` is a list of `ZDCChatAgent` which contains all info about an agent
 * Observer must be removed before deallocation.
 *
 * @param target the listener to add
 * @param selector the selector to be invoked on the target
 */
- (void)addObserver:(id)target forAgentEvents:(SEL)selector;

/**
 * Remove typing observers for the target.
 * @param target the listener to remove
 */
- (void)removeObserverForAgentEvents:(id)target;

/**
 * Listen for upload events.
 * To get the upload value, you should get the notification object and cast it to `ZDCChatUpload`
 * `ZDCChatUpload *upload = notification.object;`. `ZDCChatUpload` contains info about the upload
 *
 * Observer must be removed before deallocation.
 *
 * @param target the listener to add
 * @param selector the selector to be invoked on the target
 */
- (void)addObserver:(id)target forUploadEvents:(SEL)selector;

/**
 * Remove upload observers for the target.
 *
 * @param target the listener to remove
 */
- (void)removeObserverForUploadEvents:(id)target;

/**
 * Listen for account events. Accout can be online or offline. To get the value in the callback method:
 * `[[ZDCChat instance].api isAccountOnline]`
 * Observer must be removed before deallocation.
 *
 * @param target the listener to add
 * @param selector the selector to be invoked on the target
 */
- (void)addObserver:(id)target forAccountEvents:(SEL)selector;

/**
 * Remove account observers for the target.
 * @param target the listener to remove
 */
- (void)removeObserverForAccountEvents:(id)target;

@end


/**
 Category containing event tracking methods
 */
@interface ZDCChatAPI (Tracking)

/**
 * Send an event to the server.
 * While chat is uninitialized events will be buffered and sent once chat is connected
 *
 * @param event the event string to be added
 */
- (void)trackEvent:(NSString*)event;

@end

@interface ZDCChatAPI (Department)

- (void)updateDepartment:(NSString *)department;

@end

@interface ZDCChatAPI (Observers)

- (void)addObserver:(id)target forDepartmentEvents:(SEL)selector;
- (void)removeObserverForDepartmentEvents:(id)target;

@end
