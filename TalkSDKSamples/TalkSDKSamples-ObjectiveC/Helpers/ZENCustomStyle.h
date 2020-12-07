//
//  ZENCustomStyle.h
//  TalkSDKSamples-ObjectiveC
//
//  Created by Michał Smaga on 04/12/2020.
//

#import <Foundation/Foundation.h>
#import <TalkSDK/TalkSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZENCustomStyle : NSObject

+ (void)applyToMicrophonePermissionScreen:(id <MicrophonePermissionScreen>)screen;
+ (void)applyToRecordingConsentScreen:(id <RecordingConsentScreen>)screen;
+ (void)applyToCallScreen:(id <CallScreen>)screen;

@end

NS_ASSUME_NONNULL_END
