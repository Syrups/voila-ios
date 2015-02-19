//
//  SettingsViewController.m
//  TenVeux
//
//  Created by Leo on 11/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserSession.h"
#import "Cache.h"
#import "UserManager.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableViewController* tableController = (UITableViewController*)self.childViewControllers[0];
    self.settingsTableView = tableController.tableView;
    self.settingsTableView.delegate = self;
    
    self.user = [Cache cachedUser];
    
    if (self.user == nil) {
        UserManager* manager = [[UserManager alloc] init];
        [manager getUser:[[UserSession sharedSession] user] withSuccess:^(User *user) {
            self.user = user;
            [self updateView];
        } failure:^{
            // ERROR
        }];
    }

}

- (IBAction)dismiss:(id)sender {
    [self.menu close:sender];
}

- (IBAction)logout:(id)sender {
    [[UserSession sharedSession] destroy];
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.menu.masterViewController.navigationController setViewControllers:@[vc] animated:YES];
}

- (void)updateView {
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self logout:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        UILabel* username = (UILabel*)[cell.contentView viewWithTag:10];
        username.text = self.user.username;
    }
}

@end
