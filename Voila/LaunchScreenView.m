//
//  LaunchScreenView.m
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "LaunchScreenView.h"
#import "PKAIDecoder.h"

@implementation LaunchScreenView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    [PKAIDecoder builAnimatedImageIn:self.loaderImage fromFile:@"loader.pkai"];
    
    return self;
}

@end
