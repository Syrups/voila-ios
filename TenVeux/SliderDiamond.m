//
//  SliderDiamond.m
//  TenVeux
//
//  Created by Leo on 30/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SliderDiamond.h"
#import "ChoiceSlider.h"

@implementation SliderDiamond

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    image.image = [UIImage imageNamed:@"choice-slider-handle"];
    [self addSubview:image];
    
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [(ChoiceSlider*)self.superview show];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    CGPoint previousLocation = [aTouch previousLocationInView:self];
    
    CGPoint currentPosition = [aTouch locationInView:self.superview];
    
    if (currentPosition.x <= 20 || currentPosition.x > self.superview.frame.size.width - 20) return;
    
    self.frame = CGRectOffset(self.frame, (location.x - previousLocation.x), 0);
    
    [(ChoiceSlider*)self.superview updateSliderWithLocation:currentPosition.x];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [(ChoiceSlider*)self.superview didRelease];
    
}

@end
