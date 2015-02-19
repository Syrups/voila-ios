//
//  Api.h
//  TenVeux
//
//  Created by Leo on 07/10/2014.
//  Copyright (c) 2014 Léo Hetsch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Api : NSObject

+ (NSURLRequest *) getBaseRequestFor:(NSString *)path authenticated:(BOOL)authenticated method:(NSString*)method;
+ (NSURLRequest *) getBaseRequestForImageUpload;
+ (void) setUserToken:(NSString *)token;
+ (void) setUserId:(NSString *)token;
+ (void) setUserName:(NSString *)username;
+ (NSString *) userToken;
+ (NSString *) userId;
+ (NSString *) userName;

@end
