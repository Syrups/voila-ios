//
//  SignUpViewController.m
//  TenVeux
//
//  Created by Leo on 08/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SignUpViewController.h"
#import "UserManager.h"
#import "Configuration.h"
#import "LoginViewController.h"
#import "AvatarViewController.h"
#import "WebViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field-username"]];
    self.passwordField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field-password"]];
    self.emailField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field-email"]];

}

- (IBAction)requestSignUp:(id)sender {
    
    
    NSString* username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""] || [email isEqualToString:@""]) {
        return;
    }
    
    self.activityIndicator.hidden = NO;
    
    UserManager* manager = [[UserManager alloc] init];
    [manager createUserWithUsername:username password:password email:email success:^{
        [self pushCaptureViewController];
    } failure:^{
        ErrorAlert(@"Impossible de se connecter pour créer le compte, veuillez réessayer plus tard");
        self.activityIndicator.hidden = YES;
    } failureUsernameUnavailable:^{
        ErrorAlert(@"Désolé, ce nom d'utilisateur est déjà pris");
        self.activityIndicator.hidden = YES;
    }];
}

- (void) pushCaptureViewController {
    AvatarViewController* vc = (AvatarViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Avatar"];
    vc.isRegistration = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dismiss:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)displayTerms:(id)sender {
    WebViewController* vc = (WebViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"Webview"];
    vc.url = @"http://syrups.github.io/tenveux/terms";
    
    [self.navigationController pushViewController:vc animated:YES];
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
