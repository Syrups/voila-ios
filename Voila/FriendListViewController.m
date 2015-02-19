//
//  FriendListViewController.m
//  TenVeux
//
//  Created by Leo on 04/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "FriendListViewController.h"
#import "UserManager.h"
#import "UserSession.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UserManager* manager = [[UserManager alloc] init];
    User* user = [[UserSession sharedSession] user];
    
    [manager getFriendsOfUser:user withSuccess:^(NSArray *friends) {
        self.friends = friends;
        [self.friendsTableView reloadData];
    } failure:^{
        NSLog(@"ERROR: Unable to fetch friend");
    }];
    
    if ([[UserSession sharedSession] hasPendingFriendRequests]) {
        self.requestsLed.hidden = NO;
    } else {
        self.requestsLed.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews {
    if ([self.friendsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.friendsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.friendsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.friendsTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)closeMenu:(id)sender {
    [self.menu close:sender];
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
    
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UserManager* manager = [[UserManager alloc] init];
        User* friend = [self.friends objectAtIndex:indexPath.row];
        [manager unfriendForUser:[[UserSession sharedSession] user] withId:friend.id withSuccess:^{
            [self.friends removeObject:friend];
            [self.friendsTableView reloadData];
            
        } failure:^{
            // ERROR
        }];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
