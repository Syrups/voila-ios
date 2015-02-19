//
//  LoginViewController.m
//  TenVeux2
//
//  Created by Leo on 27/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "LoginViewController.h"
#import "UserSession.h"
#import "Configuration.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.registerButton.layer.borderColor = RgbColorAlpha(124, 125, 129, 1).CGColor;
    [self.passwordField setLeftImage:[UIImage imageNamed:@"field-password.png"]];
    
    [[UserSession sharedSession] load];
//    [[UserSession sharedSession] destroy];
    
    if ([[UserSession sharedSession] isAuthenticated]) {
        [self pushCaptureViewControllerAnimated:NO];
    }
}

- (IBAction)requestLogin:(id)sender {
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        return;
    }
    
    self.activityIndicator.hidden = NO;
    
    [[UserSession sharedSession] authenticateWithUsername:username password:password success:^(UserSession* session){
        [session store]; // cache session information
        
        [self pushCaptureViewControllerAnimated:NO];
    } failure:^{
        ErrorAlert(@"Nom d'utilisateur ou mot de passe invalide");
        self.activityIndicator.hidden = YES;
    }];
}

- (void) pushCaptureViewControllerAnimated:(BOOL)animated {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture"];
    [self.navigationController setViewControllers:@[vc] animated:animated];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
