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

- (void)sendPropositionWithImage:(UIImage *)image users:(NSArray *)userIds success:(void (^)())success failure:(void (^)())failure {
    
    ImageUploader* uploader = [[ImageUploader alloc] init];
    
    [uploader uploadImage:image withSuccess:^(NSString *filename) {
        NSMutableURLRequest* request = [Api getBaseRequestFor:@"/propositions" authenticated:YES method:@"POST"].mutableCopy;
        [request setHTTPBody:[self httpBodyForFilename:filename users:userIds]];
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

-(NSData*)httpBodyForFilename:(NSString*)filename users:(NSArray *)userIds {
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
    
    NSString* body = [NSString stringWithFormat:@"{ \"image\": \"%@\", \"receivers\": %@ }", filename, usersJson];
    
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}

@end
