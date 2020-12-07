//
//  ZENCustomStyle.m
//  TalkSDKSamples-ObjectiveC
//
//  Created by Michał Smaga on 04/12/2020.
//

@import UIKit;

#import "ZENCustomStyle.h"

@implementation ZENCustomStyle

+ (void)applyToMicrophonePermissionScreen:(id <MicrophonePermissionScreen>)screen
{
    screen.backgroundColor = [UIColor lightGrayColor];

    screen.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    screen.titleLabel.textColor = [UIColor whiteColor];

    screen.messageLabel.font = [UIFont systemFontOfSize:24];
    screen.messageLabel.textColor = [UIColor whiteColor];

    screen.allowButton.layer.cornerRadius = 14;
    screen.allowButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    [screen.allowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [screen.allowButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];

    screen.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [screen.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

+ (void)applyToRecordingConsentScreen:(id <RecordingConsentScreen>)screen
{
    screen.backgroundColor = [UIColor lightGrayColor];

    screen.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    screen.titleLabel.textColor = [UIColor whiteColor];

    screen.messageLabel.font = [UIFont systemFontOfSize:16];
    screen.messageLabel.textColor = [UIColor whiteColor];

    screen.startCallButton.layer.cornerRadius = 14;
    screen.startCallButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [screen.startCallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [screen.startCallButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];

    screen.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [screen.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    screen.activityIndicatorView.color = [UIColor whiteColor];

    screen.consentSwitchView.backgroundColor = [UIColor colorWithRed:112/255 green:165/255 blue:255/255 alpha:.75];
    screen.consentSwitch.onTintColor = [UIColor magentaColor];
    screen.messageLabel.textColor = [UIColor whiteColor];
}

+ (void)applyToCallScreen:(UIViewController<CallScreen> *)screen
{
    UIImage *image = [UIImage imageNamed:@"callBackground"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];

    backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [screen.view addSubview:backgroundImageView];
    [screen.view sendSubviewToBack:backgroundImageView];

    [NSLayoutConstraint activateConstraints:@[
        [backgroundImageView.leadingAnchor constraintEqualToAnchor:screen.view.leadingAnchor],
        [backgroundImageView.trailingAnchor constraintEqualToAnchor:screen.view.trailingAnchor],
        [backgroundImageView.topAnchor constraintEqualToAnchor:screen.view.topAnchor],
        [backgroundImageView.bottomAnchor constraintEqualToAnchor:screen.view.bottomAnchor]
    ]];

    NSArray<UILabel *> *labels = @[screen.callLoadingView.titleLabel,
                                   screen.callErrorView.titleLabel,
                                   screen.callTimerView.titleLabel];
    for (UILabel *label in labels) {
        label.font = [UIFont boldSystemFontOfSize:24];
        label.textColor = [UIColor blackColor];
    }

    screen.callButtonsView.speakerTitleLabel.font = [UIFont boldSystemFontOfSize:12];
    screen.callButtonsView.hangUpTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    screen.callButtonsView.muteTitleLabel.font = [UIFont boldSystemFontOfSize:12];

    screen.callErrorView.retryButton.backgroundColor = [UIColor redColor];
    [screen.callErrorView.cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    if (@available(iOS 13.0, *)) {
        screen.callLoadingView.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleLarge;
    } else {
        screen.callLoadingView.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }

    screen.callLoadingView.activityIndicator.color = [UIColor whiteColor];

    screen.callTimerView.timerLabel.font = [UIFont boldSystemFontOfSize:74];
    screen.callTimerView.timerLabel.textColor = [UIColor whiteColor];
    screen.callTimerView.timerLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    screen.callTimerView.timerLabel.layer.shadowRadius = 14;
    screen.callTimerView.timerLabel.layer.shadowOpacity = 0.55;
    screen.callTimerView.timerLabel.layer.shadowOffset = CGSizeZero;
}

@end
