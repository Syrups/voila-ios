//
//  Cache.m
//  TenVeux
//
//  Created by Leo on 17/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cache.h"
#import "UserManager.h"
#import "PropositionManager.h"
#import "SDWebImagePrefetcher.h"
#import "Configuration.h"

@implementation Cache

static User* _user;
static NSArray* _friends;
static NSArray* _propositions;
static UIImage* takenImage;

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

+ (void)preloadReceivedPropositionsWithSuccess:(void (^)())success {
    PropositionManager* manager = [[PropositionManager alloc] init];
    
    [manager findPendingPropositionsAndAnswersWithSuccess:^(NSArray *propositions, NSArray *answers) {
        _propositions = propositions;
        
        NSMutableArray* urls = [NSMutableArray array];
        
        for (Proposition* p in propositions) {
            [urls addObject:[NSURL URLWithString:MediaUrl(p.image)]];
        }
        
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls progress:nil completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
            success();
        }];
        
    } failure:nil];
}

+ (void)cachePropositions:(NSArray *)propositions {
    _propositions = propositions;
}

+ (NSArray *)cachedPropositions {
    return _propositions;
}

+ (BOOL)hasCachedPropositions {
    return _propositions.count > 0;
}

+ (void)setTakenImage:(UIImage *)image {
    takenImage = image;
}

+ (UIImage *)takenImage {
    return takenImage;
}

@end
