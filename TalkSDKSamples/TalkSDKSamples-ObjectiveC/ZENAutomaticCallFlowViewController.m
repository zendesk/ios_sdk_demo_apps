//
//  ZENAutomaticCallFlowViewController.m
//  TalkSDKSamples-ObjectiveC
//
//  Created by Michał Smaga on 03/12/2020.
//

#import "ZENAutomaticCallFlowViewController.h"
#import "ZendeskConfig.h"
@import ZendeskCoreSDK;
@import TalkSDK;

@interface ZENAutomaticCallFlowViewController ()

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *agentAvailabilityLabel;

@property (strong, nonatomic) ZDKTalk *talk;

@end

@implementation ZENAutomaticCallFlowViewController

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
    [self.talk startCallToDigitalLine:ZENZendeskDigitalLine];
}

@end
