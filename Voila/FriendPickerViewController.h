//
//  FriendPickerViewController.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proposition.h"

@interface FriendPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UITableView* friendsTableView;
@property (strong, nonatomic) NSArray* friends;
@property (strong, nonatomic) NSMutableArray* selectedFriends;
@property (strong, nonatomic) IBOutlet UIButton* sendButton;
@property (assign, nonatomic) BOOL isOriginal;
@property (strong, nonatomic) Proposition* originalProposition;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@property (strong, nonatomic) IBOutlet UIButton* privateButton;
@property (strong, nonatomic) IBOutlet UIButton* publicButton;
@property (strong, nonatomic) IBOutlet UIView* privateSelector;
@property (strong, nonatomic) IBOutlet UIView* publicSelector;

@property (strong, nonatomic) IBOutlet UILabel* errorLabel;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;


@end
