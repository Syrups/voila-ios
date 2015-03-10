//
//  OutboxManager.h
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proposition.h"
#import "PropositionManager.h"

@interface OutboxManager : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) PropositionManager* manager;
@property (strong, nonatomic) NSMutableArray* pendingShipments;

+ (OutboxManager*)sharedManager;
- (void)addPendingPropositionWithImage:(UIImage*)image users:(NSArray*)userIds originalProposition:(Proposition*)original;
- (void)attemptSendAll;
- (void)attemptSendPropositionAtIndex:(NSUInteger)index;

@end

@protocol OutboxManagerDelegate <NSObject>

- (void)outboxManager:(OutboxManager*)manager didFailSendingPropositionAtIndex:(NSUInteger)index;
- (void)outboxManager:(OutboxManager *)manager didSucceedSendingPropositionAtIndex:(NSUInteger)index;

@end
