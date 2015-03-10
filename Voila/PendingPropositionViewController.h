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
@property (strong, nonatomic) IBOutlet UILabel* senderNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView* senderAvatar;
@property (strong, nonatomic) IBOutlet UIImageView* image;
@property (strong, nonatomic) IBOutlet UIButton* okButton;

- (void)didAnswerYesToCurrentProposition;
- (void)didAnswerNoToCurrentProposition;
- (IBAction)requestNext:(id)sender; 

@end
