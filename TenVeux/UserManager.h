//
//  UserManager.h
//  TenVeux2
//
//  Created by Leo on 30/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

- (void)getFriendsOfUser:(User*)user withSuccess:(void(^)(NSArray* friends))success failure:(void(^)())failure;

@end
