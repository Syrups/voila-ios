//
//  Answer.h
//  TenVeux2
//
//  Created by Leo on 28/01/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import "JSONModel.h"
#import "Proposition.h"

@interface Answer : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) Proposition* proposition;
@property (strong, nonatomic) NSString* answer;
@property (strong, nonatomic) NSString* answeredAt;
@property (assign, nonatomic) BOOL acknowledged;

@end
