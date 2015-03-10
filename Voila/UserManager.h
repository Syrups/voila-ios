//
//  UserManager.h
//  TenVeux2
//
//  Created by Leo on 30/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@interface UserManager : NSObject

- (void)createUserWithUsername:(NSString*)username password:(NSString*)password email:(NSString*)email success:(void(^)())success failure:(void(^)())failure failureUsernameUnavailable:(void(^)())failureUsernameUnavailable;
- (void)getFriendsOfUser:(User*)user withSuccess:(void(^)(NSArray* friends))success failure:(void(^)())failure;
- (void)findUsersMatchingQuery:(NSString*)query withSuccess:(void(^)(NSArray* results))success failure:(void(^)())failure;
- (void)getFriendRequestsForUser:(User*)user withSuccess:(void(^)(NSArray* requests))success failure:(void(^)())failure;
- (void)addFriendForUser:(User*)user withId:(NSString*)friendId withSuccess:(void(^)())success failure:(void(^)())failure;
- (void)dismissFriendRequestForUser:(User*)user withId:(NSString*)friendId withSuccess:(void(^)())success failure:(void(^)())failure;
- (void)unfriendForUser:(User*)user withId:(NSString*)friendId withSuccess:(void(^)())success failure:(void(^)())failure;
- (void)getUser:(User*)user withSuccess:(void(^)(User* user))success failure:(void(^)())failure;
- (void)updateAvaterOfUser:(User*)user withImage:(UIImage*)image success:(void(^)(NSURL*))success failure:(void(^)())failure;



@end
