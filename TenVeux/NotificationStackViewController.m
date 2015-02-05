//
//  NotificationStackViewController.m
//  TenVeux2
//
//  Created by Leo on 29/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "NotificationStackViewController.h"

@implementation NotificationStackViewController

- (void)viewDidLoad {
    NSLog(@"%@", self.answersStack);
    
    UIViewController* child = [self.storyboard instantiateViewControllerWithIdentifier:@"PendingProposition"];
    [self addChildViewController:child];
    [self.view addSubview:child.view];
    [self.view sendSubviewToBack:child.view];
    
    self.childViewController = child;
}

- (void)next {
    
}

- (IBAction)dismiss {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
