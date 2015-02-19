//
//  ImageUploader.m
//  TenVeux
//
//  Created by Leo on 12/10/2014.
//  Copyright (c) 2014 Léo Hetsch. All rights reserved.
//

#import "ImageUploader.h"
#import "AFNetworking.h"
#import "Api.h"
#import "Configuration.h"

@implementation ImageUploader

- (void)uploadImage:(UIImage*)image withSuccess:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
    NSMutableURLRequest *request = [[Api getBaseRequestForImageUpload] mutableCopy];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"JKGQHSGQF7QSFQ89SFQ897SF";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", kImageUploadHttpParameterName, kImageUploadHttpFileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [self makeRequest:[request copy] withSuccess:success failure:failure];
}

- (void)makeRequest:(NSURLRequest *)request withSuccess:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([responseObject objectForKey:@"filename"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [op start];
}

@end
