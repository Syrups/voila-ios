//
//  ProfileViewController.m
//  TenVeux
//
//  Created by Leo on 11/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserManager.h"
#import "PropositionManager.h"
#import "UserSession.h"
#import "Cache.h"
#import "UIImageView+WebCache.h"
#import "Configuration.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserManager* manager = [[UserManager alloc] init];
    PropositionManager* propManager = [[PropositionManager alloc] init];
    
    self.user = [Cache cachedUser];
    [self updateView];
    
    if (self.user == nil) {
        [manager getUser:[[UserSession sharedSession] user] withSuccess:^(User *user) {
            self.user = user;
            [self updateView];
        } failure:^{
            // ERROR
        }];
    }
    
    [propManager getPopularPropositionsOfUser:[[UserSession sharedSession] user] success:^(NSArray *popular) {
        self.popular = popular;
        [self updatePopularScrollview];
    } failure:^{
        // ERROR
    }];
    
    [propManager getSentPropositionsOfUser:[[UserSession sharedSession] user] success:^(NSArray *sent) {
        self.sent = sent;
    } failure:^{
        // ERROR
    }];
    
    self.profileImage.layer.borderColor = [UIColor grayColor].CGColor;
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

- (void)updatePopularScrollview {
    NSUInteger i = 0;
    
    for (Proposition* proposition in self.popular) {
        UIView* popularView = [[UIView alloc] initWithFrame:CGRectMake(i*100 + 15, 0, 90, 120)];
        UIImageView* popularImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        UILabel* popularLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 90, 20)];
        popularLabel.text = [NSString stringWithFormat:@"%ld pris", proposition.resenders.count];
        popularLabel.textAlignment = NSTextAlignmentCenter;
        popularLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16];
        popularLabel.textColor = [UIColor whiteColor];
        [popularImage sd_setImageWithURL:[NSURL URLWithString:[kMediaUrl stringByAppendingString:proposition.image]]];
        
        [popularView addSubview:popularImage];
        [popularView addSubview:popularLabel];
        
        [self.popularScrollView addSubview:popularView];
        i++;
    }
    
    [self.popularScrollView setContentSize:CGSizeMake(i*100, 120)];
}

@end
