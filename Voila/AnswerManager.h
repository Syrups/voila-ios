//
//  AnswerManager.h
//  TenVeux
//
//  Created by Leo on 13/02/2015.
//  Copyright (c) 2015 Syrup Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Answer.h"

@interface AnswerManager : NSObject

- (void)acknowledgeAnswer:(Answer*)answer withSuccess:(void(^)())success failure:(void(^)())failure;

@end
