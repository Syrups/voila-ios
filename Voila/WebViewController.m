//
//  WebViewController.m
//  Voila
//
//  Created by Leo on 25/03/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.url == nil) {
       self.url = @"http://syrups.github.io/tenveux/terms";
    }
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
