//
//  Cache.h
//  TenVeux
//
//  Created by Leo on 17/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <UIKit/UIKit.h>

@interface Cache : NSObject

+ (void)preloadUserData:(User*)user withSuccess:(void(^)())success;
+ (User*)cachedUser;
+ (void)preloadUserFriends:(User*)user withSuccess:(void(^)())success;
+ (NSArray *)cachedFriends;
+ (void)preloadReceivedPropositionsWithSuccess:(void(^)())success;
+ (void)cachePropositions:(NSArray*)propositions;
+ (NSArray*)cachedPropositions;
+ (BOOL)hasCachedPropositions;
+ (void)setTakenImage:(UIImage*)image;
+ (UIImage*)takenImage;

@end
