//
//  UserSession.h
//  TenVeux2
//
//  Created by Leo on 27/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserSession : NSObject

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* token;

+ (UserSession*)sharedSession;

- (User*)user;
- (void)load;
- (BOOL) isAuthenticated;
- (void) authenticateWithUsername:(NSString*)username password:(NSString*)password success:(void(^)(UserSession* session))success failure:(void(^)())failure;
- (void) destroy;
- (void) store;

@end
