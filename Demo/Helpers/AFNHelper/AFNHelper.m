//
//  AFNHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "AFNHelper.h"
#import <AFNetworking/AFNetworking.h>
#import "UtilityClass.h"
#import "Constant.h"

@implementation AFNHelper

+ (AFNHelper *)sharedInstance {
    static AFNHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AFNHelper alloc] init];
    });
    return instance;
}

- (void)request:(NSString *)url method:(NSString *)method paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
{
    if (block) {
        dataBlock = [block copy];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/x-www-form-urlencoded"];
    
    if ([method isEqualToString:POST_METHOD]) {
        [manager POST:url parameters:paramaters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            if (dataBlock) {
                if (responseObject == nil)
                    dataBlock(task.response, nil);
                else
                    dataBlock(responseObject, nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            if (dataBlock) {
                dataBlock(nil, error);
            }
        }];
    } else {
        [manager GET:url parameters:paramaters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            if (dataBlock) {
                if(responseObject == nil)
                    dataBlock(task.response, nil);
                else
                    dataBlock(responseObject, nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            if (dataBlock) {
                dataBlock(nil, error);
            }
        }];
    }
}

- (void)request:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(CompletionBlock)block
{
    if (block) {
        dataBlock = [block copy];
    }
    
    UIImage *scaleImage = [[UtilityClass sharedInstance] scaleAndRotateImage:image];
    NSData *imageToUpload = UIImageJPEGRepresentation(scaleImage, 1.0);
    
    if (imageToUpload)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 600;
        [manager POST:url parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:imageToUpload name:PARAM_IMAGE fileName:@"temp.jpg" mimeType:@"image/jpg"];
         } progress:nil success:^(NSURLSessionTask *operation, id responseObject) {
             
             if (dataBlock) {
                 dataBlock(responseObject, nil);
             }
         } failure:^(NSURLSessionTask *operation, NSError *error) {

             if (dataBlock) {
                 dataBlock(nil, error);
             }
         }];
    }
}

@end
