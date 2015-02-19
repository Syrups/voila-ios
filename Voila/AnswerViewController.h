//
//  AnswerViewController.h
//  TenVeux
//
//  Created by Leo on 12/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface AnswerViewController : UIViewController

@property (strong, nonatomic) Answer* answer;

@property (strong, nonatomic) IBOutlet UIImageView* image;
@property (strong, nonatomic) IBOutlet UIView* topView;
@property (strong, nonatomic) IBOutlet UIView* overlay;
@property (strong, nonatomic) IBOutlet UILabel* positive;
@property (strong, nonatomic) IBOutlet UILabel* negative;
@property (strong, nonatomic) IBOutlet UIButton* okButton;
@property (strong, nonatomic) IBOutlet UIImageView* fromProfileImage;
@property (strong, nonatomic) IBOutlet UIImageView* toProfileImage;

@end
