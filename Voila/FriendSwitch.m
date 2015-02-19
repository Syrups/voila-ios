//
//  FriendSwitch.m
//  TenVeux
//
//  Created by Leo on 10/10/2014.
//  Copyright (c) 2014 Léo Hetsch. All rights reserved.
//

#import "FriendSwitch.h"

@implementation FriendSwitch

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    self.on = false;
    self.imageView.image = [UIImage imageNamed:@"icon-toggle-friend-off"];
    
    [self addTarget:self action:@selector(toggleOnOff) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void) toggleOnOff {
    self.on = !self.on;
    
    NSString* name = self.on ? @"icon-toggle-friend-on" : @"icon-toggle-friend-off";
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

@end
