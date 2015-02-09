//
//  MenuViewController.m
//  TenVeux
//
//  Created by Leo on 31/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)didSelectItem:(UIView*)sender {
    [self.masterViewController menuRequestFullSize];
    UIViewController* detailVc = nil;
    
    switch (sender.tag) {
        case 10:
            detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuReception"];
            break;
        
        case 20:
            detailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuFriends"];
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
