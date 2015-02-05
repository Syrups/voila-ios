//
//  PendingPropositionViewController.h
//  TenVeux2
//
//  Created by Leo on 29/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proposition.h"

@interface PendingPropositionViewController : UIViewController

@property (strong, nonatomic) Proposition* proposition;
@property (strong, nonatomic) IBOutlet UIView* topView;

@end
