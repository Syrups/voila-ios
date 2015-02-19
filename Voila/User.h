//
//  User.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"

@protocol User <NSObject>
@end


@interface User : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString<Optional>* token;
@property (assign, nonatomic) NSInteger sent;
@property (assign, nonatomic) NSInteger taken;
@property (strong, nonatomic) NSArray<User, Optional, ConvertOnDemand>* friends;

@end
