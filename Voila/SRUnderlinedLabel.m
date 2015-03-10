//
//  SRUnderlinedLabel.m
//  TenVeux
//
//  Created by Leo on 05/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "SRUnderlinedLabel.h"
#import "Configuration.h"

@implementation SRUnderlinedLabel

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = RgbColorAlpha(124, 125, 129, 1).CGColor;
    [self.layer addSublayer:bottomBorder];
    
    UIColor *color = RgbColorAlpha(124, 125, 129, 1);
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    self.textColor = RgbColorAlpha(124, 125, 129, 1);
    
    self.leftViewMode = UITextFieldViewModeAlways;
//    self.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"field-username"]];
    self.leftView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftView.frame = CGRectMake(0, 0, 25, self.frame.size.height);
    
    return self;
}


@end
