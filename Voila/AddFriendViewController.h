//
//  AddFriendViewController.h
//  TenVeux
//
//  Created by Leo on 05/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@interface AddFriendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView* resultsTableView;
@property (strong, nonatomic) IBOutlet UITextField* searchField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) NSArray* results;
@property (strong, nonatomic) UserManager* userManager;

@end
