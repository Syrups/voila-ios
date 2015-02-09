//
//  Proposition.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"
#import "User.h"

@protocol Proposition <NSObject>
@end

@interface Proposition : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* image;
@property (assign, nonatomic) BOOL isPrivate;
@property (strong, nonatomic) User<ConvertOnDemand>* sender;
@property (strong, nonatomic) NSArray<User, ConvertOnDemand>* receivers;
@property (strong, nonatomic) NSArray<User, ConvertOnDemand>* resenders;
@property (strong, nonatomic) NSArray<User, ConvertOnDemand>* takers;
@property (strong, nonatomic) NSArray<User, ConvertOnDemand>* dismissers;
@property (strong, nonatomic) NSString* sentAt;
@property (strong, nonatomic) Proposition<Optional>* originalProposition;


@end
