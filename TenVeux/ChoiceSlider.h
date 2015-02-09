//
//  ChoiceSlider.h
//  TenVeux
//
//  Created by Leo on 30/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderDiamond.h"
#import "PendingPropositionViewController.h"

#define kSliderAnswerNone 0
#define kSliderAnswerYes  1
#define kSliderAnswerNo   2

@interface ChoiceSlider : UIControl

@property (strong, nonatomic) SliderDiamond* handler;
@property (strong, nonatomic) IBOutlet UIView* overlay;
@property (strong, nonatomic) IBOutlet UIView* positiveUi;
@property (strong, nonatomic) IBOutlet UIView* negativeUi;
@property (strong, nonatomic) IBOutlet UIView* resendButton;
@property (strong, nonatomic) IBOutlet UIView* nextButton;

@property (strong, nonatomic) IBOutlet PendingPropositionViewController* viewController;

- (void)show;
- (void)hide;
- (void)updateSliderWithLocation:(CGFloat)location;
- (void)didRelease;

@end
