//
//  AwaitingFriendsViewController.h
//  TenVeux
//
//  Created by Leo on 05/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwaitingFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* requests;
@property (strong, nonatomic) IBOutlet UITableView* requestsTableView;
@property (strong, nonatomic) IBOutlet UIImageView* profileImageBackground;

@end
