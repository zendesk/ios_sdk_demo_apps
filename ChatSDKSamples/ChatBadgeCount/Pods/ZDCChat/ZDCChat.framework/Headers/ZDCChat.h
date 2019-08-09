/*
 *
 *  ZDCChat.h
 *  ZDCChat
 *
 *  Created by Zendesk on 22/04/2014.
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
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

// Chat API SDK Version
#define ZDC_CHAT_SDK_VERSION @"1.4.1"

#if MODULES_DISABLED
#import <ZDCChatAPI/ZDCChatAPI.h>
#else
@import ZDCChatAPI;
#endif

#import "ZDCConfig.h"

#import "ZDCOfflineMessageHandler.h"

#import "ZDCChatViewController.h"

#import "ZDCChatOverlay.h"
#import "ZDCChatAvatar.h"

#import "ZDCChatCell.h"
#import "ZDCVisitorChatCell.h"
#import "ZDCAgentChatCell.h"
#import "ZDCFormCellSingleLine.h"
#import "ZDCFormCellDepartment.h"
#import "ZDCFormCellMessage.h"
#import "ZDCJoinLeaveCell.h"
#import "ZDCAgentAttachmentCell.h"
#import "ZDCVisitorAttachmentCell.h"
#import "ZDCRatingCell.h"
#import "ZDCChatTimedOutCell.h"
#import "ZDCSystemTriggerCell.h"
#import "ZDCAccountOfflineCell.h"
#import "ZDCAgentTypingCell.h"



/**
 * Visitor config block.
 * @param visitor the visitor info to be updated
 */
typedef void (^ZDCVisitorConfigBlock) (ZDCVisitorInfo *visitor);

/**
 * Session config block.
 * @param info the session info object which can be used to set pre-chat data requirements and session metadata
 */
typedef void (^ZDCConfigBlock) (ZDCConfig *config);


#pragma mark -


/**
 * The core of the Chat SDK, all objects related to chat can be accessed
 * from here either directly or indirectly.
 */
@interface ZDCChat : NSObject


/**
 * The chat session.
 */
@property (nonatomic, strong) ZDCChatAPI *api;

/**
 * The chat overlay used when chat is minimised.
 */
@property (nonatomic, strong) id<ZDCChatOverlayDelegate> overlay;

/**
 * The view controller for the chat UI.
 */
@property (nonatomic, strong) ZDCChatViewController *chatViewController;

/**
 * This property allows interception of the offline message handling process. If set then the action 
 * block will be invoked when there are no agents online, the user is offered the option of sending 
 * an offline message, and taps the button to send a message.
 */
@property (nonatomic, strong) ZDCOfflineMessageHandler *offlineMessageHandler;

/*
 * Defines whether an available chat session should be resumed on launch.
 */
@property (nonatomic, assign) BOOL shouldResumeOnLaunch;

/**
 * Sets the parameter by the same name on the chat view controller when it is pushed onto an existing view controller.
 */
@property (nonatomic, assign) BOOL hidesBottomBarWhenPushed;

/**
 * Get the number of messsages received while the chat UI interface was minimised.
 */
@property (nonatomic, assign, readonly) NSInteger unreadMessagesCount;


/**
 * Singleton instance of the ZDCChat component.
 */
+ (instancetype)instance;

/**
 * Initializes the chat session
 * @param accountKey accountKey used
 */
+ (void)initializeWithAccountKey:(NSString*)accountKey;

/**
 * Update the visitor data.
 * @param visitorConfig visitor config block
 */
+ (void)updateVisitor:(ZDCVisitorConfigBlock)visitorConfig;

/**
 * Show the chat UI and begin connecting to the chat server.
 * This method will present the chat UI in a new modal.
 * @param sessionConfig block in which the session config may be used to override the 
 *        defaults for this session only, leave nil to use the default config
 */
+ (void)startChat:(ZDCConfigBlock)sessionConfig;

/**
 * Push the chat UI on to the supplied nav controller and begin connecting to the chat server.
 * @param navController the navigation controller in which to push the chat UI
 * @param configOverride block in which the session config is updated as desired for this session, leave nil to use the default config
 */
+ (void)startChatIn:(UINavigationController*)navController withConfig:(ZDCConfigBlock)configOverride;

/**
 * End the chat session and dismiss the UI.
 */
+ (void)endChat;

/**
 * Minise the chat window.
 */
+ (void)minimiseChat;

/**
 * Set the push token for this session.
 *
 * @param token the push token received from the didRegisterForRemoteNotificationsWithDeviceToken response
 */
+ (void) setPushToken:(NSData*)token;

/**
 * If a user revokes push permissions you can remove the push token from the session with this method.
 */
+ (void) clearPushToken;

/**
 * Push notifications which are received in the app delegate didReceiveRemoteNotification method should be passed to
 * the SDK via this method.
 */
+ (void) didReceiveRemoteNotification:(NSDictionary*)userInfo;

- (void)enableAgentAvailabilityObserving:(BOOL)enable;

@end

