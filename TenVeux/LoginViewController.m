//
//  LoginViewController.m
//  TenVeux2
//
//  Created by Leo on 27/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "LoginViewController.h"
#import "UserSession.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UserSession sharedSession] load];
    
    NSLog(@"%@", [UserSession sharedSession].token);
    
    if ([[UserSession sharedSession] isAuthenticated]) {
        [self pushCaptureViewController];
    }
}

- (IBAction)requestLogin:(id)sender {
    self.activityIndicator.hidden = NO;
    
    [[UserSession sharedSession] authenticateWithUsername:self.usernameField.text password:self.passwordField.text success:^(UserSession* session){
        [session store]; // cache session information
        
        [self pushCaptureViewController];
    } failure:^{
        // ERROR
    }];
}

- (void) pushCaptureViewController {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture"];
    [self.navigationController setViewControllers:@[vc]];
}

@end
