//
//  ZENManualCallScreensViewController.m
//  TalkSDKSamples-ObjectiveC
//
//  Created by Michał Smaga on 04/12/2020.
//

#import "ZENManualCallScreensViewController.h"
#import "ZendeskConfig.h"
#import "ZENCustomStyle.h"
@import ZendeskCoreSDK;
@import TalkSDK;

@interface ZENManualCallScreensViewController ()

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *agentAvailabilityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *customizeSwitch;

@property (strong, nonatomic) ZDKTalk *talk;

@end

@implementation ZENManualCallScreensViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.callButton.enabled = NO;

    [ZDKZendesk initializeWithAppId:ZENZendeskAppID clientId:ZENZendeskClientID zendeskUrl:ZENZendeskURL];

    id<ZDKObjCIdentity> userIdentity = [[ZDKObjCAnonymous alloc] initWithName:nil email:nil];
    [[ZDKZendesk instance] setIdentity:userIdentity];

    self.talk = [[ZDKTalk alloc] initWithZendesk:[ZDKZendesk instance]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkAgentAvailability];
}

#pragma mark - Line status and agent availability

- (void)checkAgentAvailability
{
    __weak typeof(self) weakSelf = self;
    [self.talk lineStatusWithDigitalLine:ZENZendeskDigitalLine
                              completion:^(id<LineStatus> _Nullable lineStatus, NSError * _Nullable error) {
        if (lineStatus != nil && error == nil) {
            [weakSelf updateAgentAvailabilityWithAvailable:lineStatus.agentAvailable];
        } else {
            [weakSelf handleLineStatusErrorWithError:error];
        }
    }];
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
    [self pushCallConfigurationScreen];
}

- (void)pushCallConfigurationScreen
{
    UIViewController<CallConfigurationScreen> *callConfigurationViewController = [self.talk makeCallConfigurationViewControllerFor:ZENZendeskDigitalLine];

    __weak typeof(self) weakSelf = self;
    [callConfigurationViewController setCancelHandler:^{
        [[weakSelf navigationController] popViewControllerAnimated:YES];
    }];

    [callConfigurationViewController setStartCallHandler:^(enum RecordingConsentAnswer answer) {
        [[weakSelf navigationController] popViewControllerAnimated:NO];
        [weakSelf presentCallScreenWithRecordingConsentAnswer:answer];
    }];

    if (self.customizeSwitch.isOn) {
        [ZENCustomStyle applyToMicrophonePermissionScreen:callConfigurationViewController.microphoneScreen];
        [ZENCustomStyle applyToRecordingConsentScreen:callConfigurationViewController.recordingConsentScreen];
    }

    [[self navigationController] pushViewController:callConfigurationViewController animated:YES];
}

- (void)presentCallScreenWithRecordingConsentAnswer:(RecordingConsentAnswer)answer
{
    ZDKTalkCallData *callData = [[ZDKTalkCallData alloc] initWithDigitalLine:ZENZendeskDigitalLine
                                                      recordingConsentAnswer:answer];
    __weak typeof(self) weakSelf = self;
    UIViewController<CallScreen> *callViewController = [self.talk makeCallViewControllerWith:callData
                                                                        callDidFinishHandler:^(NSTimeInterval callDuration, NSError  * _Nullable error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    }];

    if (self.customizeSwitch.isOn) {
        [ZENCustomStyle applyToCallScreen:callViewController];
    }

    callViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:callViewController animated:NO completion:nil];
}

@end
