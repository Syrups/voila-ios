//
//  UserSession.m
//  TenVeux2
//
//  Created by Leo on 27/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "UserSession.h"
#import "AFNetworking.h"
#import "Api.h"
#import "Configuration.h"

@implementation UserSession

static UserSession* sharedSession;

+ (UserSession*)sharedSession {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSession = [[UserSession alloc] init];
    });
    
    return sharedSession;
}

- (User *)user {
    User* u = [[User alloc] init];
    u.id = self.id;
    u.token = self.token;
    
    return u;
}

- (void)load {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    self.id = [defaults objectForKey:kSessionStoreId];
    self.token = [defaults objectForKey:kSessionStoreToken];
    self.avatarUrl = [NSURL URLWithString:(NSString*)[defaults objectForKey:kSessionStoreAvatarUrl]];
    
    [Api setUserId:self.id];
    [Api setUserToken:self.token];
}

- (BOOL)isAuthenticated {
    return self.token != nil;
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(UserSession* session))success failure:(void (^)())failure {
    
    NSMutableURLRequest* request = [Api getBaseRequestFor:@"/users/authenticate" authenticated:NO method:@"POST"].mutableCopy;
    [request setHTTPBody:[[NSString stringWithFormat:@"{ \"username\": \"%@\", \"password\": \"%@\" }", username, password] dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Api setUserId:[responseObject objectForKey:@"id"]];
        [Api setUserToken:[responseObject objectForKey:@"token"]];
        
        self.id = [responseObject objectForKey:@"id"];
        self.token = [responseObject objectForKey:@"token"];
//        self.avatarUrl = [kMediaUrl stringByAppendingString:(NSString*)[responseObject objectForKey:@"avatar"]];
        
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (void)store {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.id forKey:kSessionStoreId];
    [defaults setObject:self.token forKey:kSessionStoreToken];
    [defaults setObject:self.avatarUrl.absoluteString forKey:kSessionStoreAvatarUrl];
    [defaults synchronize];
}

- (void)destroy {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kSessionStoreId];
    [defaults removeObjectForKey:kSessionStoreToken];
    [defaults removeObjectForKey:kSessionStoreAvatarUrl];
    [defaults synchronize];
}

@end
