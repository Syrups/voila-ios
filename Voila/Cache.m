//
//  Cache.m
//  TenVeux
//
//  Created by Leo on 17/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "Cache.h"
#import "UserManager.h"
#import "PropositionManager.h"

@implementation Cache

static User* _user;
static NSArray* _friends;

+ (void)preloadUserData:(User *)user withSuccess:(void (^)())success {
    UserManager* manager = [[UserManager alloc] init];
    
    [manager getUser:user withSuccess:^(User *resultUser) {
        _user = resultUser;
    } failure:nil];
}

+ (User *)cachedUser {
    return _user;
}

+ (void)preloadUserFriends:(User *)user withSuccess:(void (^)())success {
    UserManager* manager = [[UserManager alloc] init];

    [manager getFriendsOfUser:user withSuccess:^(NSArray *friends) {
        _friends = friends;
    } failure:nil];
}

+ (NSArray *)cachedFriends {
    return _friends;
}

@end
