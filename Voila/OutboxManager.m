//
//  OutboxManager.m
//  Voila
//
//  Created by Leo on 20/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "OutboxManager.h"
#import "PropositionManager.h"
#import "Configuration.h"

@implementation OutboxManager

static OutboxManager* sharedManager;

+ (OutboxManager*)sharedManager {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[OutboxManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    self.pendingShipments = [NSMutableArray array];
    self.manager = [[PropositionManager alloc] init];
    
//    [self loadCachedState];
    
    return self;
}

- (void)addPendingPropositionWithImage:(UIImage *)image users:(NSArray *)userIds isPrivate:(BOOL)isPrivate originalProposition:(Proposition *)original {
    if (original == nil) {
        original = [[Proposition alloc] init];
    }
    
    NSDictionary* data = @{ @"image": image, @"users": userIds, @"isPrivate": [NSString stringWithFormat:@"%ud", (unsigned int)isPrivate], @"original": original };
    [self.pendingShipments addObject:data];
    
    // NSLog(@"PENDING SHIPMENT QUEUED");
    
    [self cacheCurrentState];
}

- (void)attemptSendPropositionAtIndex:(NSUInteger)index {
    NSDictionary* data = [self.pendingShipments objectAtIndex:index];
    
    UIImage* image = [data objectForKey:@"image"];
    NSArray* users = [data objectForKey:@"users"];
    BOOL private = [(NSString*)[data objectForKey:@"isPrivate"] boolValue];
    Proposition* original = [data objectForKey:@"original"];
    
    if (original.id == nil) original = nil;
    
    // NSLog(@"%@", image);
    
    [self.manager sendPropositionWithImage:image users:users isPrivate:private originalProposition:original success:^{
        if (self.delegate != nil) {
            [self.delegate outboxManager:self didSucceedSendingPropositionAtIndex:index];
        }
    } failure:^{
        if (self.delegate != nil) {
            [self.delegate outboxManager:self didFailSendingPropositionAtIndex:index];
        }
    }];
}

- (void)attemptSendAll {
    for (int i = 0 ; i < self.pendingShipments.count ; i++) {
        [self attemptSendPropositionAtIndex:i];
    }
}


- (void)cacheCurrentState {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:kOutboxCacheFile];
    NSMutableArray* state = [NSMutableArray array];
    
    for (NSDictionary* shipment in self.pendingShipments) {
        Proposition* original = (Proposition*)[shipment objectForKey:@"original"];
        NSMutableDictionary* encodedShipment = [NSMutableDictionary dictionaryWithDictionary:shipment];
        [encodedShipment setObject:[original toDictionary] forKey:@"original"];
        [state addObject:encodedShipment];
    }
    
    // NSLog(@"%@", filePath);
    
    [state writeToFile:filePath atomically:YES];
}

- (void)loadCachedState {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:kOutboxCacheFile];
    
    self.pendingShipments = [NSMutableArray arrayWithContentsOfFile:filePath];
}

@end
