//
//  FriendPickerViewController.m
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FriendPickerViewController.h"
#import "PendingPropositionViewController.h"
#import "UserManager.h"
#import "UserSession.h"
#import "FriendSwitch.h"
#import "PropositionManager.h"
#import "OutboxManager.h"
#import "PKAIDecoder.h"
#import "Configuration.h"
#import "UIImageView+WebCache.h"

@implementation FriendPickerViewController {
    BOOL private;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    private = NO;
    
    self.friends = @[];
    self.selectedFriends = [NSMutableArray array];
    
    UserManager* manager = [[UserManager alloc] init];
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
    [self.friendsTableView addSubview:refresh];
    self.refreshControl = refresh;
    
    self.activityIndicator.hidden = NO;
    
    [manager getFriendsOfUser:[[UserSession sharedSession] user] withSuccess:^(NSArray *friends) {
        self.friends = friends;
        [self.friendsTableView reloadData];
        self.activityIndicator.hidden = YES;
    } failure:^{
        self.errorLabel.hidden = NO;
        self.activityIndicator.hidden = YES;
    }];
    
    self.friendsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.friendsTableView.bounds.size.width, 30)];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, self.view.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor grayColor].CGColor;
    [self.friendsTableView.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.friendsTableView.frame.size.height-1, self.view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
//    [self.friendsTableView.layer addSublayer:bottomBorder];
    

}

- (void)refreshList {
    UserManager* manager = [[UserManager alloc] init];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [manager getFriendsOfUser:[[UserSession sharedSession] user] withSuccess:^(NSArray *friends) {
        self.friends = friends;
        [self.friendsTableView reloadData];
        self.errorLabel.hidden = YES;
        [self.refreshControl endRefreshing];
    } failure:^{
        self.errorLabel.hidden = NO;
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)toggleFriendSelection:(FriendSwitch*)sender {
    if ([self.selectedFriends containsObject:sender.friendId]) {
        [self.selectedFriends removeObject:sender.friendId];
    } else {
        [self.selectedFriends addObject:sender.friendId];
    }
    
    if (self.selectedFriends.count > 0) {
        self.sendButton.enabled = YES;
        self.sendButton.alpha = 1;
    } else {
        self.sendButton.enabled = NO;
        self.sendButton.alpha = 0.5f;
    }
    
    // NSLog(@"%@", self.selectedFriends);
}

- (IBAction)send:(id)sender {
    PropositionManager* manager = [[PropositionManager alloc] init];
    UIView* sending = [[[NSBundle mainBundle] loadNibNamed:@"Sending" owner:self options:nil] objectAtIndex:0];
    sending.frame = self.view.frame;
    
    UIImageView* loaderImage = (UIImageView*)[sending.subviews objectAtIndex:0];
    [PKAIDecoder builAnimatedImageIn:loaderImage fromFile:@"loader"];
    
    [self.view addSubview:sending];
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
    [manager sendPropositionWithImage:self.image users:self.selectedFriends isPrivate:private originalProposition:self.originalProposition  success:^{
        [sending removeFromSuperview];
        [self close];
    } failure:^{
        // ERROR
        [[OutboxManager sharedManager] addPendingPropositionWithImage:self.image users:self.selectedFriends isPrivate:private originalProposition:self.originalProposition];
//        // NSLog(@"%@", [[OutboxManager sharedManager] pendingShipments]);
        [sending removeFromSuperview];
        [self close];
    }];
}

- (void)close {
    if (self.isOriginal) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self dismiss:nil];
        [(PendingPropositionViewController*)self.parentViewController requestNext:nil];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    User* friend = [self.friends objectAtIndex:indexPath.row];
    if (self.isOriginal && [friend.id isEqualToString:self.originalProposition.sender.id]) {
        return 0;
    }
    
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    User* friend = [self.friends objectAtIndex:indexPath.row];
    
//    // NSLog(@"%@", self.originalProposition.allReceivers);
    
    // Check if this friend has already received this proposition
    // and if so, disable sending to him
    if (!self.isOriginal) {
        if ([self.originalProposition.allReceivers containsObject:friend.id]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCellAlready"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCellAlready"];
                
            }
        }
    } else {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
        }
    }
    
    FriendSwitch* btn = (FriendSwitch*)[cell.contentView viewWithTag:30];
    btn.friendId = friend.id;
    [btn addTarget:self action:@selector(toggleFriendSelection:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView* profilePic = (UIImageView*)[cell.contentView viewWithTag:10];
    profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (friend.avatar) {
        [profilePic sd_setImageWithURL:[NSURL URLWithString:MediaUrl(friend.avatar)]];
    }
    
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:20];
    name.text = friend.username;
    
    if (btn.on && ![self.selectedFriends containsObject:friend.id]) [btn toggleOnOff];
    if (!btn.on && [self.selectedFriends containsObject:friend.id]) [btn toggleOnOff];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.friendsTableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"FriendCellAlready"]) {
        return;
    }
    
    FriendSwitch* btn = (FriendSwitch*)[cell.contentView viewWithTag:30];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)toggleVisibility:(id)sender {
    private = !private;
    
    if (private) {
        self.privateButton.alpha = 1;
        self.publicButton.alpha = 0.5f;
        self.privateSelector.alpha = 1;
        self.publicSelector.alpha = 0;
    } else {
        self.privateButton.alpha = 0.5f;
        self.publicButton.alpha = 1;
        self.privateSelector.alpha = 0;
        self.publicSelector.alpha = 1;
    }
}

#pragma mark - Navigation

- (IBAction)dismiss:(id)sender {
    [self.parentViewController.navigationController popViewControllerAnimated:NO];
//    [UIView animateWithDuration:0.3f animations:^{
//        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
//    } completion:^(BOOL finished) {
//        
//    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
