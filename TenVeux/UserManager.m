//
//  UserManager.m
//  TenVeux2
//
//  Created by Leo on 30/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UserManager.h"
#import "Api.h"
#import "AFNetworking.h"

@implementation UserManager

- (void)getFriendsOfUser:(User *)user withSuccess:(void (^)(NSArray *))success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/friends", user.id] authenticated:YES method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSError* err = nil;
        NSArray* friends = [User arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            NSLog(@"%@", err);
        }
        
        success(friends);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [op start];
}

@end
