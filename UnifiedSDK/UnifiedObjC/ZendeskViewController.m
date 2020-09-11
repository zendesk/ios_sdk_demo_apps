//
//  ZendeskViewController.m
//  UnifiedObjC
//
//  Created by Killian Smith  on 11/09/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

#import "ZendeskViewController.h"
#import "ZendeskMessaging.h"

@interface ZendeskViewController ()

@end

@implementation ZendeskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startMessaging:(id)sender {
    [self presentModally];
}

- (void) pushViewController {
    UIViewController *viewController = [ZendeskMessaging buildUI];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) presentModally {
    UIViewController *viewController = [ZendeskMessaging buildUI];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Close"
                                                                                       style: UIBarButtonItemStylePlain
                                                                                      target: self
                                                                                      action: @selector(dismiss)];

    UINavigationController *chatController = [[UINavigationController alloc] initWithRootViewController: viewController];
    [self.navigationController presentViewController:chatController animated:YES completion:nil];
}

- (void) dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
