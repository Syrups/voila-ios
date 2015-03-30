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
#import "UserSession.h"
#import "AppDelegate.h"
#import "ImageUploader.h"
#import "Configuration.h"

@implementation UserManager

- (void)getFriendsOfUser:(User *)user withSuccess:(void (^)(NSArray *))success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/friends", user.id] authenticated:YES method:@"GET"].mutableCopy;
    
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad]; // cache friends
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request.copy];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSError* err = nil;
        NSArray* friends = [User arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(friends);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        if (failure) failure();
    }];
    
    [op start];
}

- (void)getFriendRequestsForUser:(User *)user withSuccess:(void (^)(NSArray *))success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/requests", user.id] authenticated:YES method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* users = [User arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(users);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
    [op start];
}

-(void)getSentFriendRequestsForUser:(User *)user withSuccess:(void (^)(NSArray *))success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/requests/sent", user.id] authenticated:YES method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* users = [User arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(users);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
    [op start];
}

- (void)findUsersMatchingQuery:(NSString *)query withSuccess:(void (^)(NSArray *))success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/find/%@", query] authenticated:YES method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        NSArray* results = [User arrayOfModelsFromDictionaries:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(results);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        if (failure) {
            failure();
        }
    }];
    
    [op start];

}

- (void)createUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email success:(void (^)())success failure:(void (^)())failure failureUsernameUnavailable:(void (^)())failureUsernameUnavailable {
    
    NSMutableURLRequest* request = [Api getBaseRequestFor:@"/users" authenticated:NO method:@"POST"].mutableCopy;
    [request setHTTPBody:[self httpBodyForUsername:username password:password email:email]];
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Api setUserId:[responseObject objectForKey:@"id"]];
        [Api setUserToken:[responseObject objectForKey:@"token"]];
        
        [[UserSession sharedSession] setId:[responseObject objectForKey:@"id"]];
        [[UserSession sharedSession] setToken:[responseObject objectForKey:@"token"]];
        [[UserSession sharedSession] store];

        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (operation.response.statusCode == 409 && failureUsernameUnavailable != nil) failureUsernameUnavailable();
        else if (failure != nil) failure();
    }];
    
    [op start];
}

- (void)addFriendForUser:(User *)user withId:(NSString *)friendId withSuccess:(void (^)())success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/addfriends", user.id] authenticated:YES method:@"PUT"].mutableCopy;
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"friend_id\": \"%@\" }", friendId] dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        [[NSURLCache sharedURLCache] removeAllCachedResponses]; // remove friends cache
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (void)unfriendForUser:(User*)user withId:(NSString *)friendId withSuccess:(void (^)())success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/unfriend", user.id] authenticated:YES method:@"PUT"].mutableCopy;
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"friend_id\": \"%@\" }", friendId] dataUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses]; // remove friends cache
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (void)getUser:(User *)user withSuccess:(void (^)(User *))success failure:(void (^)())failure {
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@", user.id] authenticated:YES method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* err = nil;
        User* user = [[User alloc] initWithDictionary:responseObject error:&err];
        
        if (err) {
            // NSLog(@"%@", err);
        }
        
        success(user);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
    }];
    
    [op start];
}

- (void)updateAvaterOfUser:(User *)user withImage:(id)image success:(void (^)(NSURL* avatarUrl))success failure:(void (^)())failure {
    ImageUploader* uploader = [[ImageUploader alloc] init];
    
    [uploader uploadImage:image withSuccess:^(NSString *filename) {
        
        // NSLog(@"%@", filename);
        
        NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@", user.id] authenticated:YES method:@"PUT"].mutableCopy;
        [request setHTTPBody:[[NSString stringWithFormat:@"{ \"avatar\": \"%@\" }", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[NSURLCache sharedURLCache] removeAllCachedResponses]; // remove friends cache
            
            success([NSURL URLWithString:MediaUrl(filename)]);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // NSLog(@"%@", error);
            failure();
        }];
        
        [op start];
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)deleteAccountOfUser:(User *)user success:(void (^)())success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@", user.id] authenticated:YES method:@"DELETE"].mutableCopy;
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses]; // remove all cache
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (void)sendPasswordResetRequestForUser:(User *)user success:(void (^)())success failure:(void (^)())failure {
    NSMutableURLRequest* request = [Api getBaseRequestFor:[NSString stringWithFormat:@"/users/%@/requestreset", user.id] authenticated:YES method:@"POST"].mutableCopy;
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses]; // remove all cache
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (NSData*)httpBodyForUsername:(NSString*)username password:(NSString*)password email:(NSString*)email {
    
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"];
    
    if (deviceToken == nil) {
        deviceToken = @"";
    }
    
    NSString* json = [NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\", \"email\": \"%@\", \"ios_device_token\": \"%@\" }", username, password, email, deviceToken];
    
    return [json dataUsingEncoding:NSUTF8StringEncoding];
}

@end
