//
//  LoginViewController.h
//  TenVeux2
//
//  Created by Leo on 27/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField* usernameField;
@property (strong, nonatomic) IBOutlet UITextField* passwordField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
