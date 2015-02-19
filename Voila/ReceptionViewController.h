//
//  ReceptionViewController.h
//  TenVeux
//
//  Created by Leo on 06/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface ReceptionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) MenuViewController* menu;
@property (strong, nonatomic) IBOutlet UICollectionView* collectionView;
@property (strong, nonatomic) NSArray* received;

@end
