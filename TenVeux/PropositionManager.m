//
//  PropositionManager.m
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "PropositionManager.h"
#import "Api.h"
#import "Proposition.h"
#import "Answer.h"
#import "AFNetworking.h"
#import "ImageUploader.h"

@implementation PropositionManager

- (void)findPendingPropositionsAndAnswersWithSuccess:(void (^)(NSArray* propositions, NSArray* answers))success failure:(void (^)())failure {

    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/pendingall", [Api userId]] authenticated:YES method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* propositions = @[];
        NSArray* answers = @[];
        NSArray* answersDics = (NSArray*)[responseObject objectForKey:@"answers"];
        NSArray* propsDics = (NSArray*)[responseObject objectForKey:@"propositions"];
        NSError* err = nil;
        
        if (answersDics.count > 0) {
            answers = [Answer arrayOfModelsFromDictionaries:answersDics];
        }
        
        if (propsDics.count > 0) {
            propositions = [Proposition arrayOfModelsFromDictionaries:(NSArray*)[responseObject objectForKey:@"propositions"] error:&err];
        }
        
        if (err) {
            NSLog(@"%@", err);
        }
        
        success(propositions, answers);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [op start];
}

- (void)getReceivedPropositionsOfUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/received", user.id] authenticated:YES method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* received = [Proposition arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            NSLog(@"%@", err);
        }
        
        success(received);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [op start];
}

- (void)sendPropositionWithImage:(UIImage *)image users:(NSArray *)userIds originalProposition:(Proposition*)original success:(void (^)())success failure:(void (^)())failure {
    
    ImageUploader* uploader = [[ImageUploader alloc] init];
    
    [uploader uploadImage:image withSuccess:^(NSString *filename) {
        NSMutableURLRequest* request = [Api getBaseRequestFor:@"/propositions" authenticated:YES method:@"POST"].mutableCopy;
        
        NSString* originalId;
        
        // Well, "original proposition" can have an original proposition too
        // Let's keep track of the real original proposition
        if (original.originalProposition != nil) {
            originalId = original.originalProposition.id;
        } else {
            originalId = original.id;
        }
        
        [request setHTTPBody:[self httpBodyForFilename:filename users:userIds original:originalId]];
        AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            failure();
        }];
        
        [op start];

    } failure:^(NSError *error) {
        failure();
    }];
}

- (void)takeProposition:(Proposition *)proposition withSuccess:(void (^)())success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/propositions/%@/take", proposition.id] authenticated:YES method:@"PUT"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (void)dismissProposition:(Proposition *)proposition withSuccess:(void (^)())success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/propositions/%@/dismiss", proposition.id] authenticated:YES method:@"PUT"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

-(NSData*)httpBodyForFilename:(NSString*)filename users:(NSArray *)userIds original:(NSString*)original {
    NSMutableString *usersJson = [NSMutableString stringWithString:@"["];
    int i = 0;
    
    for (NSString* u in userIds) {
        [usersJson appendString:[NSString stringWithFormat:@"\"%@\"", u]];
        if (i != userIds.count-1) {
            [usersJson appendString:@", "];
        }
        i++;
    }
    
    [usersJson appendString:@"]"];
    
    NSString* body;
    
    if (original == nil) {
        body = [NSString stringWithFormat:@"{ \"image\": \"%@\", \"receivers\": %@ }", filename, usersJson];
    } else {
        body = [NSString stringWithFormat:@"{ \"image\": \"%@\", \"receivers\": %@, \"originalProposition\": \"%@\" }", filename, usersJson, original];
    }
    
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}

@end
