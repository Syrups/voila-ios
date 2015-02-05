//
//  PropositionManager.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PropositionManager : NSObject

- (void) findPendingPropositionsAndAnswersWithSuccess:(void(^)(NSArray* propositions, NSArray* answers))success failure:(void(^)())failure;

- (void) sendPropositionWithImage:(UIImage*)image users:(NSArray*)userIds success:(void(^)())success failure:(void(^)())failure;

@end
