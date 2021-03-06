//
//  AddFriendViewController.m
//  TenVeux
//
//  Created by Leo on 05/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AddFriendViewController.h"
#import "User.h"
#import "UserSession.h"
#import "UIImageView+WebCache.h"
#import "Configuration.h"

@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userManager = [[UserManager alloc] init];
    
    self.searchField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field-username"]];
    
    [self.profileImageBackground sd_setImageWithURL:[[UserSession sharedSession] avatarUrl]];
}

- (void)viewDidLayoutSubviews {
    if ([self.resultsTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.resultsTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.resultsTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.resultsTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)search {
    NSString* query = [self.searchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.activityIndicator.hidden = NO;
    [self.userManager findUsersMatchingQuery:query withSuccess:^(NSArray *results) {
        self.activityIndicator.hidden = YES;
        self.results = results;
        [self.resultsTableView reloadData];
    } failure:^{
        // ERROR
        self.activityIndicator.hidden = YES;
        self.results = [NSArray array];
        [self.resultsTableView reloadData];
    }];
}

- (IBAction)requestFriendAdd:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.resultsTableView];
    NSIndexPath *indexPath = [self.resultsTableView indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell* cell = [self.resultsTableView cellForRowAtIndexPath:indexPath];
    UIButton* btn = (UIButton*)[cell.contentView viewWithTag:30];
    btn.hidden = YES;
    UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[cell.contentView viewWithTag:40];
    indicator.hidden = NO;
    
    UserManager* manager = [[UserManager alloc] init];
    User* user = [[UserSession sharedSession] user];
    User* userToAdd = [self.results objectAtIndex:indexPath.row];
    
    [manager addFriendForUser:user withId:userToAdd.id withSuccess:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^{
        ErrorAlert(@"La demande d'ami n'a pu être envoyé, réessayez plus tard");
        btn.hidden = YES;
        UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[cell.contentView viewWithTag:40];
        indicator.hidden = NO;
    }];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self search];
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    User* result = [self.results objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    
    UIImageView* profilePic = (UIImageView*)[cell.contentView viewWithTag:10];
    profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (result.avatar) {
        [profilePic sd_setImageWithURL:[NSURL URLWithString:MediaUrl(result.avatar)]];
    }
    
    UILabel* name = (UILabel*)[cell.contentView viewWithTag:20];
    name.text = result.username;
    
    
    return cell;
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
