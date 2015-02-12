//
//  SettingsViewController.m
//  TenVeux
//
//  Created by Leo on 11/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserSession.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableViewController* tableController = (UITableViewController*)self.childViewControllers[0];
    self.settingsTableView = tableController.tableView;
    self.settingsTableView.delegate = self;
}

- (IBAction)dismiss:(id)sender {
    [self.menu close:sender];
}

- (IBAction)logout:(id)sender {
    [[UserSession sharedSession] destroy];
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self.menu.masterViewController.navigationController setViewControllers:@[vc] animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self logout:nil];
    }
}

@end
