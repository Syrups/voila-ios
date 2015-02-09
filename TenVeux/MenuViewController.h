//
//  MenuViewController.h
//  TenVeux
//
//  Created by Leo on 31/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureViewController.h"

@interface MenuViewController : UIViewController

@property (strong, nonatomic) CaptureViewController* masterViewController;

- (IBAction)close:(id)sender;
- (void)didCloseMenu;

@end
