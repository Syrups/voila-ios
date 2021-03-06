//
//  FriendListViewController.h
//  TenVeux
//
//  Created by Leo on 04/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface FriendListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MenuViewController* menu;
@property (strong, nonatomic) NSMutableArray* friends;
@property (strong, nonatomic) NSMutableArray* sentRequests;
@property (strong, nonatomic) NSMutableArray* filteredFriends;
@property (strong, nonatomic) IBOutlet UITableView* friendsTableView;
@property (strong, nonatomic) IBOutlet UIView* requestsLed;
@property (strong, nonatomic) IBOutlet UIImageView* profileImageBackground;

@end
