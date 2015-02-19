//
//  SignUpViewController.h
//  TenVeux
//
//  Created by Leo on 08/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRUnderlinedLabel.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet SRUnderlinedLabel* usernameField;
@property (strong, nonatomic) IBOutlet SRUnderlinedLabel* passwordField;
@property (strong, nonatomic) IBOutlet SRUnderlinedLabel* emailField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
