//
//  HistoryViewController.h
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutboxManager.h"

@interface HistoryViewController : UIViewController <OutboxManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* historyTableView;
@property (strong, nonatomic) OutboxManager* outbox;
@property (strong, nonatomic) NSArray* sent;

@property (strong, nonatomic) UIView* sending;
@property (strong, nonatomic) UIRefreshControl* refreshControl;

@end
