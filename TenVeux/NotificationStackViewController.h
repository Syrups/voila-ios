//
//  NotificationStackViewController.h
//  TenVeux2
//
//  Created by Leo on 29/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationStackViewController : UIViewController

@property (strong, nonatomic) NSArray* propositionStack;
@property (strong, nonatomic) NSArray* answersStack;
@property (strong, nonatomic) UIViewController* childViewController;
@property (strong, nonatomic) IBOutlet UILabel* notifCountLabel;
@property (strong, nonatomic) IBOutlet UIButton* backButton;

- (IBAction)requestNextInStack:(id)sender;
- (void)hideTopControls;
- (void)showTopControls;

@end
