//
//  PropositionManager.m
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "PropositionManager.h"
#import "Api.h"
#import "Configuration.h"
#import "Proposition.h"
#import "Answer.h"
#import "AFNetworking.h"
#import "ImageUploader.h"
#import "SDWebImagePrefetcher.h"

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
            answers = [Answer arrayOfModelsFromDictionaries:answersDics error:&err];
        }
        
        if (propsDics.count > 0) {
            propositions = [Proposition arrayOfModelsFromDictionaries:(NSArray*)[responseObject objectForKey:@"propositions"] error:&err];
        }
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(propositions, answers);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        
        if (failure) failure();
    }];
    
    [op start];
}

- (void)getReceivedPropositionsOfUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/received", user.id] authenticated:YES method:@"GET"].mutableCopy;
    
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad]; // cache received propositions
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request.copy];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* received = [Proposition arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(received);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
    [op start];
}

- (void)sendPropositionWithImage:(UIImage *)image users:(NSArray *)userIds isPrivate:(BOOL)isPrivate originalProposition:(Proposition*)original success:(void (^)())success failure:(void (^)())failure {
    
    ImageUploader* uploader = [[ImageUploader alloc] init];
    
    if (original == nil) {
        [uploader uploadImage:image withSuccess:^(NSString *filename) {
            
            // Also cache uploaded image to local phone cache
            NSURL* url = [NSURL URLWithString:MediaUrl(filename)];
            [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[url]];
            
            NSMutableURLRequest* request = [Api getBaseRequestFor:@"/propositions" authenticated:YES method:@"POST"].mutableCopy;
            
            NSString* originalId;
            
            // Well, "original proposition" can have an original proposition too
            // Let's keep track of the real original proposition
            if (original.originalProposition != nil) {
                originalId = original.originalProposition.id;
            } else {
                originalId = original.id;
            }
            
            [request setHTTPBody:[self httpBodyForFilename:filename users:userIds isPrivate:isPrivate original:originalId]];
            AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            
            op.responseSerializer = [AFJSONResponseSerializer serializer];
            
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                success();
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"%@", error);
                failure();
            }];
            
            [op start];
            
        } failure:^(NSError *error) {
            failure();
        }];
    } else { // original one, no need to reupload the image
        NSMutableURLRequest* request = [Api getBaseRequestFor:@"/propositions" authenticated:YES method:@"POST"].mutableCopy;
        
        NSString* originalId;
        
        // Well, "original proposition" can have an original proposition too
        // Let's keep track of the real original proposition
        if (original.originalProposition != nil) {
            originalId = original.originalProposition.id;
        } else {
            originalId = original.id;
        }
        
        [request setHTTPBody:[self httpBodyForFilename:original.image users:userIds isPrivate:isPrivate original:originalId]];
        AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"%@", error);
            failure();
        }];
        
        [op start];
    }
}

- (void)takeProposition:(Proposition *)proposition withSuccess:(void (^)())success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/propositions/%@/take", proposition.id] authenticated:YES method:@"PUT"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
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
        // NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (void)getPopularPropositionsOfUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:@"/propositions/popular" authenticated:YES method:@"GET"].mutableCopy;
//    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad]; // cache popular propositions
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request.copy];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* received = [Proposition arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(received);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
    [op start];
}

- (void)getSentPropositionsOfUser:(User *)user success:(void (^)(NSArray *))success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/sent", user.id] authenticated:YES method:@"GET"].mutableCopy;
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad]; // cache popular propositions
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request.copy];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* sent = [Proposition arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(sent);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
    [op start];
}

-(NSData*)httpBodyForFilename:(NSString*)filename users:(NSArray *)userIds isPrivate:(BOOL)isPrivate original:(NSString*)original {
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
        body = [NSString stringWithFormat:@"{ \"image\": \"%@\", \"receivers\": %@, \"isPrivate\": %u }", filename, usersJson, (unsigned int)isPrivate];
    } else {
        body = [NSString stringWithFormat:@"{ \"image\": \"%@\", \"receivers\": %@, \"originalProposition\": \"%@\" }", filename, usersJson, original];
    }
    
    return [body dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Cache management

- (void)clearCacheForSentPropositionsForUser:(User*)user {
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/sent", user.id] authenticated:YES method:@"GET"]];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
