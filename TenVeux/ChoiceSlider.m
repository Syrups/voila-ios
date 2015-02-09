//
//  ChoiceSlider.m
//  TenVeux
//
//  Created by Leo on 30/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "ChoiceSlider.h"
#import "SliderDiamond.h"
#import "UIView+draggable.h"
#import "Configuration.h"

@implementation ChoiceSlider {
    NSMutableArray* bullets;
    NSUInteger lastValue;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    bullets = [NSMutableArray array];
    
    for (int i = 0 ; i <= 15 ; i++) {
        UIView* circle = [[UIView alloc] initWithFrame:CGRectMake(i*15, self.frame.size.height/2, 4, 4)];
        circle.layer.cornerRadius = 2;
        circle.backgroundColor = [UIColor whiteColor];
        circle.alpha = 0;
        [self addSubview:circle];
        [bullets addObject:circle];
    }
    
    SliderDiamond* handler = [[SliderDiamond alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40, self.frame.size.height/2 - 40, 80, 80)];
    [self addSubview:handler];
    self.handler = handler;
    
    return self;
}

- (void)show {
    lastValue = 7;
    [UIView animateWithDuration:0.2f animations:^{
        self.overlay.alpha = 0.6f;
    }];
    [bullets enumerateObjectsUsingBlock:^(UIView* b, NSUInteger idx, BOOL *stop) {
        b.alpha = 0.5f;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2f animations:^{
        self.overlay.alpha = 0;
    }];
    
    [bullets enumerateObjectsUsingBlock:^(UIView* b, NSUInteger idx, BOOL *stop) {
        b.alpha = 0;
    }];
    [UIView animateWithDuration:0.3f animations:^{
        self.negativeUi.alpha = 0;
        self.positiveUi.alpha = 0;
    }];
}

- (void)updateSliderWithLocation:(CGFloat)location {
    CGFloat n = location * 15 / 220;
    lastValue = (int) n;
    
    [bullets enumerateObjectsUsingBlock:^(UIView* b, NSUInteger idx, BOOL *stop) {

        if (idx > n-6 && idx < n+6) {
            [b setAlpha:0.75f];
        } else if (idx > n-3 && idx < n+3) {
            [b setAlpha:1];
        } else {
            [b setAlpha:0.5f];
        }
        
        if (idx > n-3 && idx < n+3 && n > 10) {
            [b setBackgroundColor:RgbColorAlpha(0, 215, 213, 1)];
        } else if (idx > n-3 && idx < n+3 && n < 5) {
            [b setBackgroundColor:RgbColorAlpha(192, 15, 71, 1)];
        } else {
            [b setBackgroundColor:[UIColor whiteColor]];
        }
        
    }];
    
    if (n > 9) {
        [UIView animateWithDuration:0.3f animations:^{
            self.positiveUi.alpha = 1;
        }];
    } else if (n < 7) {
        [UIView animateWithDuration:0.3f animations:^{
            self.negativeUi.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.negativeUi.alpha = 0;
            self.positiveUi.alpha = 0;
        }];
    }
}

- (void)didRelease {
    
    
    if (lastValue > 9) {
        [UIView animateWithDuration:0.2f animations:^{
            CGRect f = self.handler.frame;
            f.origin.x = self.frame.size.width-50;
            self.handler.frame = f;
            self.positiveUi.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                self.alpha = 0;
                self.nextButton.alpha = 1;
                self.resendButton.alpha = 1;
                self.viewController.topView.backgroundColor = [UIColor clearColor];
                [self.viewController.view bringSubviewToFront:self.viewController.topView];
                [self.viewController didAnswerYesToCurrentProposition];
            }];
        }];
    }
    
    else if (lastValue < 6) {
        [UIView animateWithDuration:0.2f animations:^{
            CGRect f = self.handler.frame;
            f.origin.x = -20;
            self.handler.frame = f;
            self.negativeUi.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                self.alpha = 0;
//                self.nextButton.alpha = 1;
//                self.resendButton.alpha = 1;
                self.resendButton.userInteractionEnabled = NO;
                self.viewController.topView.backgroundColor = [UIColor clearColor];
                [self.viewController.view bringSubviewToFront:self.viewController.topView];
                [self.viewController didAnswerNoToCurrentProposition];
            }];
        }];
    }
    
    else {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect f = self.handler.frame;
            f.origin.x = self.frame.size.width/2-40;
            self.handler.frame = f;
        }];
        [self hide];
    }
}

@end
