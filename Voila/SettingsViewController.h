//
//  SettingsViewController.h
//  TenVeux
//
//  Created by Leo on 11/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "User.h"

@interface SettingsViewController : UIViewController <UITableViewDelegate>

@property (strong, nonatomic) MenuViewController* menu;
@property (strong, nonatomic) UITableView* settingsTableView;
@property (strong, nonatomic) User* user;

@end
