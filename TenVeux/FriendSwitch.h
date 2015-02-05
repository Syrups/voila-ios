//
//  FriendSwitch.h
//  TenVeux
//
//  Created by Leo on 10/10/2014.
//  Copyright (c) 2014 Léo Hetsch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendSwitch : UIButton

@property (strong, nonatomic) NSString* friendId;
@property (assign, nonatomic) BOOL on;

- (void) toggleOnOff;


@end
