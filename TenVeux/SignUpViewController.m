//
//  SignUpViewController.m
//  TenVeux
//
//  Created by Leo on 08/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SignUpViewController.h"
#import "UserManager.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)requestSignUp:(id)sender {
    self.activityIndicator.hidden = NO;
    
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    UserManager* manager = [[UserManager alloc] init];
    [manager createUserWithUsername:username password:password email:email success:^{
        [self pushCaptureViewController];
    } failure:nil];
}

- (void) pushCaptureViewController {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Capture"];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController setViewControllers:@[vc]];
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
