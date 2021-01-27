//
//  ZENAllCustomViewController.m
//  TalkSDKSamples-ObjectiveC
//
//  Created by Michał Smaga on 07/12/2020.
//

#import "ZENAllCustomViewController.h"

#import <ZendeskCoreSDK/ZendeskCoreSDK.h>
#import <TalkSDK/TalkSDK.h>
#import "ZendeskConfig.h"
@import AVFoundation;

@interface ZENAllCustomViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *microphonePermissionView;
@property (weak, nonatomic) IBOutlet UIStackView *recordingConsentView;
@property (weak, nonatomic) IBOutlet UISwitch *recordingConsentSwitch;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *agentAvailabilityLabel;

@property (weak, nonatomic) IBOutlet UIStackView *ongoingCallView;
@property (weak, nonatomic) IBOutlet UILabel *callDurationLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioRoutingButton;
@property (weak, nonatomic) IBOutlet UILabel *speakerSwitchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *speakerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *muteSwitchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *muteSwitch;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;

@property (strong, nonatomic) ZDKTalk *talk;
@property (assign, nonatomic) RecordingConsent recordingConsentConfiguration;
@property (strong, nonatomic) id <TalkCall> talkCall;

@property (strong, nonatomic) NSTimer *callTimer;
@property (strong, nonatomic) NSDateComponentsFormatter *durationFormatter;

@end

@implementation ZENAllCustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.microphonePermissionView.hidden = YES;
    self.recordingConsentView.hidden = YES;
    self.callButton.enabled = NO;
    self.ongoingCallView.hidden = YES;

    [ZDKZendesk initializeWithAppId:ZENZendeskAppID clientId:ZENZendeskClientID zendeskUrl:ZENZendeskURL];

    id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
    [[ZDKZendesk instance] setIdentity:userIdentity];

    self.talk = [[ZDKTalk alloc] initWithZendesk:[ZDKZendesk instance]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkMicrophonePermission];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([self isMovingFromParentViewController]) {
        [self stopTimer];
        [self disconnectCall];
    }
}

- (RecordingConsentAnswer)recordingConsentAnswer
{
    RecordingConsentAnswer answer = RecordingConsentAnswerUnknown;

    if (self.recordingConsentConfiguration == RecordingConsentOptIn || self.recordingConsentConfiguration == RecordingConsentOptOut) {
        answer = self.recordingConsentSwitch.isOn ? RecordingConsentAnswerOptedIn : RecordingConsentAnswerOptedOut;
    }

    return answer;
}

- (NSDateComponentsFormatter *)durationFormatter
{
    if (!_durationFormatter) {
        _durationFormatter = [[NSDateComponentsFormatter alloc] init];
        _durationFormatter.allowedUnits = NSCalendarUnitMinute|NSCalendarUnitSecond;
        _durationFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    }

    return _durationFormatter;
}

#pragma mark - Microphone access permission

- (void)checkMicrophonePermission
{
    switch ([AVAudioSession sharedInstance].recordPermission) {
        case AVAudioSessionRecordPermissionUndetermined:
            [self askForMicrophonePermission];
            break;
        case AVAudioSessionRecordPermissionGranted:
            [self checkAgentAvailability];
            break;
        case AVAudioSessionRecordPermissionDenied:
            [self showNoMicrophonePermissionInfo];
            break;
    }
}

- (void)askForMicrophonePermission
{
    __weak typeof(self) weakSelf = self;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [weakSelf checkAgentAvailability];
            } else {
                [weakSelf showNoMicrophonePermissionInfo];
            }
        });
    }];
}

- (void)showNoMicrophonePermissionInfo
{
    self.microphonePermissionView.hidden = YES;
}

#pragma mark - Line status and agent availability

- (void)checkAgentAvailability
{
    __weak typeof(self) weakSelf = self;
    [self.talk lineStatusWithDigitalLine:ZENZendeskDigitalLine
                              completion:^(id<LineStatus> _Nullable lineStatus, NSError * _Nullable error) {
        if (lineStatus != nil && error == nil) {
            [weakSelf updateRecordingConsentConfigurationWithRecordingConsent:lineStatus.recordingConsent];
            [weakSelf updateAgentAvailabilityWithAvailable:lineStatus.agentAvailable];
        } else {
            [weakSelf handleLineStatusErrorWithError:error];
        }
    }];
}

- (void)updateRecordingConsentConfigurationWithRecordingConsent:(RecordingConsent)configuration
{
    self.recordingConsentConfiguration = configuration;

    switch (configuration) {
        case RecordingConsentOptIn:
            self.recordingConsentView.hidden = NO;
            self.recordingConsentSwitch.on = NO;
            break;
        case RecordingConsentOptOut:
            self.recordingConsentView.hidden = NO;
            self.recordingConsentSwitch.on = YES;
            break;
        case RecordingConsentUnknown:
            self.recordingConsentView.hidden = YES;
            break;
    }
}

- (void)updateAgentAvailabilityWithAvailable:(BOOL)available
{
    if (available) {
        self.callButton.enabled = YES;
        self.agentAvailabilityLabel.hidden = YES;
    } else {
        self.callButton.enabled = NO;
        self.agentAvailabilityLabel.text = @"No agent available";
        self.agentAvailabilityLabel.textColor = [UIColor darkGrayColor];
        self.agentAvailabilityLabel.hidden = NO;

        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf checkAgentAvailability];
        });
    }
}

- (void)handleLineStatusErrorWithError:(NSError *)error
{
    self.callButton.enabled = NO;
    self.agentAvailabilityLabel.text = @"An error occured. Please try again later";
    self.agentAvailabilityLabel.textColor = [UIColor redColor];
    self.agentAvailabilityLabel.hidden = NO;

    [self showAlertWithTitle:@"Failure" andMessage:[error localizedDescription]];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Making a call

- (IBAction)callButtonTapped:(id)sender
{
    [self makeCall];
}

- (void)makeCall
{
    if (self.talkCall != nil) {
        [self disconnectCall];
    }

    ZDKTalkCallData *callData = [[ZDKTalkCallData alloc] initWithDigitalLine:ZENZendeskDigitalLine
                                                      recordingConsentAnswer:[self recordingConsentAnswer]];
    __weak typeof(self) weakSelf = self;
    self.talkCall = [self.talk callWithCallData:callData statusChangeHandler:^(enum CallStatus status, NSError *error) {
        [weakSelf handleCallStatusChangeToStatus:status error:error];
    }];

    self. callDurationLabel.text = @"00:00";
}

- (void)disconnectCall
{
    [self.talkCall disconnect];
    self.talkCall = nil;
}

- (void)handleCallStatusChangeToStatus:(CallStatus)status error:(NSError *)error
{
    switch (status) {
        case CallStatusConnecting:
            self.agentAvailabilityLabel.text = @"Connecting...";
            self.agentAvailabilityLabel.textColor = [UIColor darkGrayColor];
            self.ongoingCallView.hidden = NO;
            self.callButton.enabled = NO;
            [self setOngoingCallControlsEnabled:NO];
            [self startTimer];
            break;
        case CallStatusConnected:
            self.agentAvailabilityLabel.text = @"";
            self.ongoingCallView.hidden = NO;
            self.callButton.enabled = NO;
            [self setOngoingCallControlsEnabled:YES];
            break;
        case CallStatusDisconnected:
            self.agentAvailabilityLabel.text = @"";
            self.ongoingCallView.hidden = NO;
            self.callButton.enabled = YES;
            [self disableOngoingCallControlsAndHideWithDelay];
            [self stopTimer];
            break;
        case CallStatusFailed:
            self.agentAvailabilityLabel.text = @"An error occured. Please try again later";
            self.agentAvailabilityLabel.textColor = [UIColor redColor];
            self.ongoingCallView.hidden = NO;
            self.callButton.enabled = YES;
            [self disableOngoingCallControlsAndHideWithDelay];
            [self stopTimer];
            break;
        default:
            break;
    }
}

- (void)disableOngoingCallControlsAndHideWithDelay
{
    [self setOngoingCallControlsEnabled:NO];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.ongoingCallView.hidden = YES;
    });
}

- (void)setOngoingCallControlsEnabled:(BOOL)enabled
{
    self.audioRoutingButton.enabled = enabled;
    self.speakerSwitchLabel.textColor = enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
    self.speakerSwitch.enabled = enabled;
    self.muteSwitchLabel.textColor = enabled ? [UIColor blackColor] : [UIColor lightGrayColor];
    self.muteSwitch.enabled = enabled;
    self.endCallButton.enabled = enabled;
}

#pragma mark - Call duration timer

- (void)startTimer
{
    __weak typeof(self) weakSelf = self;
    self.callTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSTimeInterval duration = weakSelf.talkCall.duration;
        if (duration < 1) {
            weakSelf.callDurationLabel.text = @"00:00";
        } else {
            weakSelf.callDurationLabel.text = [weakSelf.durationFormatter stringFromTimeInterval:duration];
        }
    }];
}

- (void)stopTimer
{
    [self.callTimer invalidate];
    self.callTimer = nil;
}

#pragma mark - Ongoing call actions

- (IBAction)audioRoutingButtonTapped:(id)sender
{
    UIAlertController *alertController = [self makeAudioRoutingAlertController];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIAlertController *)makeAudioRoutingAlertController
{
    __weak typeof(self) weakSelf = self;
    id<AudioRoutingOption> currentOption = self.talkCall.audioRouting;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Audio Routing"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    for (id<AudioRoutingOption> option in self.talkCall.availableAudioRoutingOptions) {
        BOOL isSelected = option.type == currentOption.type && option.name == currentOption.name;

        UIAlertAction *action = [UIAlertAction actionWithTitle:option.name
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.talkCall.audioRouting = option;
        }];
        [action setValue:@(isSelected) forKey:@"checked"];
        [alertController addAction:action];

    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];

    return alertController;
}

- (IBAction)speakerSwitchValueChanged:(id)sender
{
    self.talkCall.audioOutput = self.speakerSwitch.isOn ? AudioOutputSpeaker : AudioOutputHeadset;
}

- (IBAction)muteSwitchValueChanged:(id)sender
{
    self.talkCall.muted = self.muteSwitch.isOn;
}

- (IBAction)endCallButtonTapped:(id)sender
{
    [self disconnectCall];
}

@end
