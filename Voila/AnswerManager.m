//
//  AnswerManager.m
//  TenVeux
//
//  Created by Leo on 13/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "AnswerManager.h"
#import "AFNetworking.h"
#import "Api.h"

@implementation AnswerManager

- (void)acknowledgeAnswer:(Answer *)answer withSuccess:(void (^)())success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/answers/%@/acknowledge", answer.id] authenticated:YES method:@"PUT"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

@end
