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
    
    NSLog(@"%@", [UserSession sharedSession].token);
    
    if ([[UserSession sharedSession] isAuthenticated]) {
        [self pushCaptureViewController];
    }
}

- (IBAction)requestLogin:(id)sender {
    self.activityIndicator.hidden = NO;
    
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [[UserSession sharedSession] authenticateWithUsername:username password:password success:^(UserSession* session){
        [session store]; // cache session information
        
        [self pushCaptureViewController];
    } failure:^{
        ErrorAlert(@"Nom d'utilisateur ou mot de passe invalide");
    }];
}

- (void) pushCaptureViewController {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture"];
    [self.navigationController setViewControllers:@[vc]];
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
