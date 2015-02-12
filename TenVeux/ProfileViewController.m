//
//  ProfileViewController.m
//  TenVeux
//
//  Created by Leo on 11/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserManager.h"
#import "UserSession.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserManager* manager = [[UserManager alloc] init];
    
    [manager getUser:[[UserSession sharedSession] user] withSuccess:^(User *user) {
        self.user = user;
        [self updateView];
    } failure:^{
        // ERROR
    }];
}

- (IBAction)dismiss:(id)sender {
    [self.menu close:sender];
}

- (void)updateView {
    self.nameLabel.text = self.user.username;
    self.takenCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.user.taken];
    self.sentCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.user.sent];
//    self.takenCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.user.taken];
}

@end
