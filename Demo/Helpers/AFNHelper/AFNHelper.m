//
//  AFNHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "AFNHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation AFNHelper

+ (AFNHelper *)sharedInstance {
    static AFNHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AFNHelper alloc] init];
        
        instance.manager = [AFHTTPSessionManager manager];
        instance.manager.requestSerializer.timeoutInterval = 600;
        instance.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@[@"text/html",@"application/json"], nil];
        instance.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        instance.manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        instance.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        instance.manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/x-www-form-urlencoded"];
    });
    return instance;
}

- (void)request:(NSString *)url method:(NSString *)method paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block {
    if ([method isEqualToString:POST_METHOD]) {
        [self.manager POST:url parameters:paramaters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            if (block) {
                if (responseObject == nil)
                    block(task.response, nil);
                else
                    block(responseObject, nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            if (block) {
                block(nil, error);
            }
        }];
    } else {
        [self.manager GET:url parameters:paramaters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            
            if (block) {
                if(responseObject == nil)
                    block(task.response, nil);
                else
                    block(responseObject, nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            if (block) {
                block(nil, error);
            }
        }];
    }
}

- (void)request:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(CompletionBlock)block {
    UIImage *scaleImage = [[UtilityClass sharedInstance] scaleAndRotateImage:image];
    NSData *imageToUpload = UIImageJPEGRepresentation(scaleImage, 1.0);
    
    if (imageToUpload) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 600;
        [manager POST:url parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:imageToUpload name:PARAM_IMAGE fileName:@"temp.jpg" mimeType:@"image/jpg"];
         } progress:nil success:^(NSURLSessionTask *operation, id responseObject) {
             
             if (block) {
                 block(responseObject, nil);
             }
         } failure:^(NSURLSessionTask *operation, NSError *error) {

             if (block) {
                 block(nil, error);
             }
         }];
    }
}

- (void)connectionChange:(StatusBlock)block {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status > 0) {
            block(YES);
        } else {
            block(NO);
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
