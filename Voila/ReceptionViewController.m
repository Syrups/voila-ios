//
//  ReceptionViewController.m
//  TenVeux
//
//  Created by Leo on 06/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ReceptionViewController.h"
#import "PropositionManager.h"
#import "UserSession.h"
#import "Proposition.h"
#import "UIImageView+WebCache.h"
#import "Configuration.h"
#import "SDWebImagePrefetcher.h"

@implementation ReceptionViewController {
    UIView* fullPreview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    PropositionManager* manager = [[PropositionManager alloc] init];
    
    [manager getReceivedPropositionsOfUser:[[UserSession sharedSession] user] success:^(NSArray *received) {
        self.received = received;
        NSMutableArray* urls = [NSMutableArray array];
        
        for (Proposition* prop in self.received) {
            NSLog(@"%@", MediaUrl(prop.image));
            [urls addObject:[NSURL URLWithString:MediaUrl(prop.image)]];
        }
        
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
        
        [self.collectionView reloadData];
    } failure:^{
        // ERROR
    }];
}

- (IBAction)dismiss:(id)sender {
    [self.menu close:sender];
}

#pragma mark - UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReceivedCell" forIndexPath:indexPath];
    Proposition* proposition = [self.received objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UIImageView* image = (UIImageView*)[cell.contentView viewWithTag:10];
    [image sd_setImageWithURL:[NSURL URLWithString:MediaUrl(proposition.image)]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.received.count;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Proposition* proposition = [self.received objectAtIndex:indexPath.row];
    UIView* full = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView* image = [[UIImageView alloc] initWithFrame:full.frame];
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

@end
