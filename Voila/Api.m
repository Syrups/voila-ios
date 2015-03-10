//
//  Api.m
//  TenVeux
//
//  Created by Leo on 07/10/2014.
//  Copyright (c) 2014 Léo Hetsch. All rights reserved.
//

#import "Api.h"
#import "AFNetworking.h"
#import "Configuration.h"

@implementation Api

static NSString *userToken;
static NSString *userId;
static NSString *userName;

+ (NSURLRequest *) getBaseRequestFor:(NSString *)path authenticated:(BOOL)authenticated method:(NSString *)method {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kApiRootUrl, path] ] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:8];
    
    [request setHTTPMethod:method];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    if (authenticated) {
        
        [mutableRequest addValue:userToken forHTTPHeaderField:@"X-Authorization-Token"];
        
    }
    
    NSLog(@"API REQUEST : %@", path);
    
    request = [mutableRequest copy];
    
    //    NSLog(@"Auth token: %@", userToken);
    
    return request;
}


+ (NSURLRequest *) getBaseRequestForImageUpload {
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@", kMediaUploadUrl] ]];
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mutableRequest addValue:userToken forHTTPHeaderField:@"X-Authorization-Token"];
    request = [mutableRequest copy];
    
    return request;
}

+ (void) setUserToken:(NSString *)token {
    NSLog(@"User API token set to: %@", token);
    userToken = token;
}

+ (void) setUserId:(NSString *)id {
    NSLog(@"User ID set to: %@", id);
    userId = id;
}

+ (void) setUserName:(NSString *)username {
    userName = username;
}

+ (NSString *) userToken {
    return userToken;
}

+ (NSString *) userId {
    return userId;
}

+ (NSString *) userName {
    return userName;
}


@end
