//
//  ZENCustomCallConfigurationViewController.m
//  TalkSDKSamples-ObjectiveC
//
//  Created by Michał Smaga on 07/12/2020.
//

#import "ZENCustomCallConfigurationViewController.h"
#import "ZendeskConfig.h"
@import ZendeskCoreSDK;
@import TalkSDK;
@import AVFoundation;

@interface ZENCustomCallConfigurationViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *microphonePermissionView;
@property (weak, nonatomic) IBOutlet UIStackView *recordingConsentView;
@property (weak, nonatomic) IBOutlet UISwitch *recordingConsentSwitch;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *agentAvailabilityLabel;

@property (strong, nonatomic) ZDKTalk *talk;
@property (assign, nonatomic) RecordingConsent recordingConsentConfiguration;

@end

@implementation ZENCustomCallConfigurationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.microphonePermissionView.hidden = YES;
    self.recordingConsentView.hidden = YES;
    self.callButton.enabled = NO;

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

- (RecordingConsentAnswer)recordingConsentAnswer
{
    RecordingConsentAnswer answer = RecordingConsentAnswerUnknown;

    if (self.recordingConsentConfiguration == RecordingConsentOptIn || self.recordingConsentConfiguration == RecordingConsentOptOut) {
        answer = self.recordingConsentSwitch.isOn ? RecordingConsentAnswerOptedIn : RecordingConsentAnswerOptedOut;
    }

    return answer;
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
    [self presentCallScreen];
}

- (void)presentCallScreen
{
    ZDKTalkCallData *callData = [[ZDKTalkCallData alloc] initWithDigitalLine:ZENZendeskDigitalLine
                                                      recordingConsentAnswer:[self recordingConsentAnswer]];
    __weak typeof(self) weakSelf = self;
    UIViewController<CallScreen> *callViewController = [self.talk makeCallViewControllerWith:callData
                                                                        callDidFinishHandler:^(NSTimeInterval callDuration, NSError  * _Nullable error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    }];

    callViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:callViewController animated:NO completion:nil];
}

@end
