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
}

- (IBAction)close:(id)sender {
    [self.masterViewController closeMenu:sender];
}

@end
