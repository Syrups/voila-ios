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

@implementation FriendPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friends = @[];
    self.selectedFriends = [NSMutableArray array];
    
    UserManager* manager = [[UserManager alloc] init];
    
    [manager getFriendsOfUser:[[UserSession sharedSession] user] withSuccess:^(NSArray *friends) {
        self.friends = friends;
        [self.friendsTableView reloadData];
    } failure:^{
        
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
    
    NSLog(@"%@", self.selectedFriends);
}

- (IBAction)send:(id)sender {
    PropositionManager* manager = [[PropositionManager alloc] init];
    UIView* sending = [[[NSBundle mainBundle] loadNibNamed:@"Sending" owner:self options:nil] objectAtIndex:0];
    sending.frame = self.view.frame;
    [self.view addSubview:sending];
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
    [manager sendPropositionWithImage:self.image users:self.selectedFriends originalProposition:self.originalProposition  success:^{
        if (self.isOriginal) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [sending removeFromSuperview];
            [self dismiss:sender];
            [(PendingPropositionViewController*)self.parentViewController requestNext:sender];
        }
    } failure:^{
        // ERROR
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    User* friend = [self.friends objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    
    UIImageView* profilePic = (UIImageView*)[cell.contentView viewWithTag:10];
    profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:20];
    name.text = friend.username;
    
    FriendSwitch* btn = (FriendSwitch*)[cell.contentView viewWithTag:30];
    btn.friendId = friend.id;
    [btn addTarget:self action:@selector(toggleFriendSelection:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self.friendsTableView cellForRowAtIndexPath:indexPath];
    FriendSwitch* btn = (FriendSwitch*)[cell.contentView viewWithTag:30];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Navigation

- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

@end
