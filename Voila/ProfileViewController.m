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

@implementation ProfileViewController {
    UIView* fullPreview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserManager* manager = [[UserManager alloc] init];
    PropositionManager* propManager = [[PropositionManager alloc] init];
    
    self.user = [Cache cachedUser];
    [self updateView];
    
    if (self.user == nil) {
        [manager getUser:[[UserSession sharedSession] user] withSuccess:^(User *user) {
            self.user = user;
            
            [self.profileImage sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.user.avatar)]];
            [self.profileImageBackground sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.user.avatar)]];
            
            [self updateView];
        } failure:^{
            // ERROR
        }];
    } else {
        if (self.user.avatar != nil) {
            [self.profileImage sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.user.avatar)]];
            [self.profileImageBackground sd_setImageWithURL:[NSURL URLWithString:MediaUrl(self.user.avatar)]];
        }
    }
    
    [propManager getPopularPropositionsOfUser:[[UserSession sharedSession] user] success:^(NSArray *popular) {
        self.popular = popular;
        [self updatePopularScrollview];
    } failure:^{
        // ERROR
    }];
    
    [propManager getSentPropositionsOfUser:[[UserSession sharedSession] user] success:^(NSArray *sent) {
        self.sent = sent;
        [self.sentCollectionView reloadData];
        
        if (self.sent.count == 0) {
            self.startLabel.hidden = NO;
        }
        
    } failure:^{
        // ERROR
    }];
    
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAvatarViewController:)];
    
    [self.profileImage addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[UserSession sharedSession] avatarUrl] != nil) {
        [self.profileImage sd_setImageWithURL:[[UserSession sharedSession] avatarUrl]];
        [self.profileImageBackground sd_setImageWithURL:[[UserSession sharedSession] avatarUrl]];
    }
}

- (IBAction)dismiss:(id)sender {
    [self.menu close:sender];
}

- (IBAction)openAvatarViewController:(id)sender {
    UIViewController* avatar = [self.storyboard instantiateViewControllerWithIdentifier:@"Avatar"];
    [self presentViewController:avatar animated:YES completion:nil];
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
        UIView* popularView = [[UIView alloc] initWithFrame:CGRectMake(i*110, 0, 90, 120)];
        UIImageView* popularImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        popularImage.contentMode = UIViewContentModeScaleAspectFill;
        popularImage.clipsToBounds = YES;
        UILabel* popularLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 90, 20)];
        popularLabel.text = [NSString stringWithFormat:@"%ld services", proposition.allReceivers.count];
        popularLabel.textAlignment = NSTextAlignmentCenter;
        popularLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:16];
        popularLabel.textColor = [UIColor whiteColor];
        [popularImage sd_setImageWithURL:[NSURL URLWithString:MediaUrl(proposition.image)]];
        
        
        [popularView addSubview:popularImage];
        [popularView addSubview:popularLabel];
        
        [self.popularScrollView addSubview:popularView];
        i++;
    }
    
    [self.popularScrollView setContentSize:CGSizeMake(i*110, 120)];
}

//-(void)didTapFullImage:(UITapGestureRecognizer*)recognizer {
//    [fullPreview removeFromSuperview];
//}

#pragma mark - UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SentCell" forIndexPath:indexPath];
    Proposition* proposition = [self.sent objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:10];
    [image sd_setImageWithURL:[NSURL URLWithString:MediaUrl(proposition.image)]];
    
    UILabel* score = (UILabel*)[cell.contentView viewWithTag:20];
    score.text = [NSString stringWithFormat:@"%ld", proposition.allReceivers.count];
    
    UIView* scoreBg = (UIView*)[cell.contentView viewWithTag:30];
    scoreBg.center = CGPointMake(CGRectGetMidX(scoreBg.frame), CGRectGetMidY(scoreBg.frame));
    scoreBg.transform = CGAffineTransformMakeRotation(45 * (M_PI / 180));
    
    [cell.contentView bringSubviewToFront:score];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Proposition* proposition = [self.sent objectAtIndex:indexPath.row];
    UIView* full = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView* image = [[UIImageView alloc] initWithFrame:full.frame];
    image.contentMode = UIViewContentModeScaleAspectFill;
    [image sd_setImageWithURL:[NSURL URLWithString:MediaUrl(proposition.image)]];
    
    [full addSubview:image];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFullImage:)];
    [full addGestureRecognizer:tap];
    
    [self.view addSubview:full];
    fullPreview = full;
}

-(void)didTapFullImage:(UITapGestureRecognizer*)recognizer {
    [fullPreview removeFromSuperview];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sent.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}


@end
