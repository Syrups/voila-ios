//
//  PropositionManager.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Proposition.h"

@interface PropositionManager : NSObject

- (void) findPendingPropositionsAndAnswersWithSuccess:(void(^)(NSArray* propositions, NSArray* answers))success failure:(void(^)())failure;

- (void)getReceivedPropositionsOfUser:(User*)user success:(void(^)(NSArray* received))success failure:(void(^)())failure;
- (void)getSentPropositionsOfUser:(User*)user success:(void(^)(NSArray* sent))success failure:(void(^)())failure;
- (void)getPopularPropositionsOfUser:(User*)user success:(void(^)(NSArray* popular))success failure:(void(^)())failure;

- (void) sendPropositionWithImage:(UIImage*)image users:(NSArray*)userIds isPrivate:(BOOL)isPrivate originalProposition:(Proposition*)original success:(void(^)())success failure:(void(^)())failure;

- (void)takeProposition:(Proposition*)proposition withSuccess:(void(^)())success failure:(void(^)())failure;
- (void)dismissProposition:(Proposition*)proposition withSuccess:(void(^)())success failure:(void(^)())failure;

# pragma mark - Cache management

- (void)clearCacheForSentPropositionsForUser:(User*)user;

@end
