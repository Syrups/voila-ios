//
//  MenuViewController.m
//  TenVeux
//
//  Created by Leo on 31/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "MenuViewController.h"
#import "UserSession.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[UserSession sharedSession] hasPendingFriendRequests]) {
        self.requestsLed.hidden = NO;
    } else {
        self.requestsLed.hidden = YES;
    }
}


- (IBAction)didSelectItem:(UIView*)sender {
    [self.masterViewController menuRequestFullSize];
    UIViewController* detailVc = nil;
    
    switch (sender.tag) {
        case 5:
            detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuProfile"];
            break;
            
        case 10:
            detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuReception"];
            break;
        
        case 20:
            detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuFriends"];
            break;
            
        case 30:
            detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
            break;
            
        default:
            break;
    }
    
    if (detailVc) {
        [detailVc setValue:self forKey:@"menu"];
        [self.navigationController pushViewController:detailVc animated:NO];
    }
}

- (IBAction)close:(id)sender {
    [self.masterViewController closeMenu:sender];
}

@end
