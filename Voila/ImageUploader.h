//
//  ImageUploader.h
//  TenVeux
//
//  Created by Leo on 12/10/2014.
//  Copyright (c) 2014 Léo Hetsch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUploader : NSObject

- (void)uploadImage:(UIImage*)image withSuccess:(void(^)(NSString* filename))success failure:(void(^)(NSError* error))failure;
- (void)makeRequest:(NSURLRequest*)request withSuccess:(void(^)(NSString* filename))success failure:(void(^)(NSError* error))failure;

@end
