//
//  FriendPickerViewController.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UITableView* friendsTableView;
@property (strong, nonatomic) NSArray* friends;
@property (strong, nonatomic) NSMutableArray* selectedFriends;
@property (strong, nonatomic) IBOutlet UIButton* sendButton;

@end
