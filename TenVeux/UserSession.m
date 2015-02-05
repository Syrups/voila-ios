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
    
    [Api setUserId:self.id];
    [Api setUserToken:self.token];
}

- (BOOL)isAuthenticated {
    return self.token != nil;
}

- (void)authenticateWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(UserSession* session))success failure:(void (^)())failure {
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:[Api getBaseRequestFor:[NSString stringWithFormat:@"/users/authenticate?username=%@&password=%@", username, password] authenticated:NO method:@"GET"]];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Api setUserId:[responseObject objectForKey:@"id"]];
        [Api setUserToken:[responseObject objectForKey:@"token"]];
        
        self.id = [responseObject objectForKey:@"id"];
        self.token = [responseObject objectForKey:@"token"];
        
        success(self);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        failure();
    }];
    
    [op start];
}

- (void)store {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.id forKey:kSessionStoreId];
    [defaults setObject:self.token forKey:kSessionStoreToken];
    [defaults synchronize];
}

- (void)destroy {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kSessionStoreId];
    [defaults removeObjectForKey:kSessionStoreToken];
    [defaults synchronize];
}

@end