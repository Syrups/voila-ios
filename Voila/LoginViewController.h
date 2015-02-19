//
//  LoginViewController.h
//  TenVeux2
//
//  Created by Leo on 27/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRUnderlinedLabel.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet SRUnderlinedLabel* usernameField;
@property (strong, nonatomic) IBOutlet SRUnderlinedLabel* passwordField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton* registerButton;

@end
