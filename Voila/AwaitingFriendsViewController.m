//
//  AwaitingFriendsViewController.m
//  TenVeux
//
//  Created by Leo on 05/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AwaitingFriendsViewController.h"
#import "User.h"
#import "UserManager.h"
#import "UserSession.h"
#import "UIImageView+WebCache.h"
#import "Configuration.h"

@interface AwaitingFriendsViewController ()

@end

@implementation AwaitingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UserManager* manager = [[UserManager alloc] init];
    User* user = [[UserSession sharedSession] user];
    
    [manager getFriendRequestsForUser:user withSuccess:^(NSArray *requests) {
        self.requests = requests.mutableCopy;
        [self.requestsTableView reloadData];
    } failure:^{
        
    }];
    
    [self.profileImageBackground sd_setImageWithURL:[[UserSession sharedSession] avatarUrl]];
}

- (IBAction)acceptRequest:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.requestsTableView];
    NSIndexPath *indexPath = [self.requestsTableView indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell* cell = [self.requestsTableView cellForRowAtIndexPath:indexPath];
    UIButton* btn = (UIButton*)[cell.contentView viewWithTag:30];
    btn.hidden = YES;
    UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[cell.contentView viewWithTag:40];
    indicator.hidden = NO;
    
    UserManager* manager = [[UserManager alloc] init];
    User* user = [[UserSession sharedSession] user];
    User* userToAdd = [self.requests objectAtIndex:indexPath.row];
    
    [manager addFriendForUser:user withId:userToAdd.id withSuccess:^{
        [self.requests removeObjectAtIndex:indexPath.row];
        [self.requestsTableView reloadData];
        
        if (self.requests.count == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [[UserSession sharedSession] setHasPendingFriendRequests:NO];
        }
    } failure:^{
        btn.hidden = NO;
        indicator.hidden = YES;
        ErrorAlert(@"Oups, une erreur est survenue. Réessayez plus tard.")
    }];
}

- (IBAction)dismissRequest:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.requestsTableView];
    NSIndexPath *indexPath = [self.requestsTableView indexPathForRowAtPoint:buttonPosition];
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.requests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    User* user = [self.requests objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    
    UIImageView* profilePic = (UIImageView*)[cell.contentView viewWithTag:10];
    profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (user.avatar) {
        [profilePic sd_setImageWithURL:[NSURL URLWithString:MediaUrl(user.avatar)]];
    }
    
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:20];
    name.text = user.username;
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
