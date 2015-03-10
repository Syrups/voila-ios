//
//  ProfileViewController.h
//  TenVeux
//
//  Created by Leo on 11/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "User.h"

@interface ProfileViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView* sentCollectionView;
@property (strong, nonatomic) MenuViewController* menu;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) NSArray* popular;
@property (strong, nonatomic) NSArray* sent;

@property (strong, nonatomic) IBOutlet UILabel* nameLabel;
@property (strong, nonatomic) IBOutlet UILabel* sentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel* acceptedCountLabel;
@property (strong, nonatomic) IBOutlet UILabel* takenCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView* profileImage;
@property (strong, nonatomic) IBOutlet UIImageView* profileImageBackground;
@property (strong, nonatomic) IBOutlet UIScrollView* popularScrollView;

@end
