//
//  NetworkHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation NetworkHelper

+ (NetworkHelper *)sharedInstance
{
    static NetworkHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkHelper alloc] init];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
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

- (void)requestGet:(NSString *)url
        paramaters:(NSMutableDictionary *)paramaters
        completion:(void (^)(id response, NSError *error))block
{
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

- (void)requestPost:(NSString *)url
         paramaters:(NSMutableDictionary *)paramaters
         completion:(void (^)(id response, NSError *error))block
{
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
}

- (void)requestPost:(NSString *)url
         paramaters:(NSMutableDictionary *)paramaters
              image:(UIImage *)image completion:(void (^)(id response, NSError *error))block
{
    UIImage *imageScale = [[UtilityClass sharedInstance] scaleAndRotateImage:image];
    NSData *imageToUpload = UIImageJPEGRepresentation(imageScale, 1.0);
    
    if (imageToUpload) {
        [self.manager POST:url parameters:paramaters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
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

- (void)requestGetBasicAuthorization:(NSString *)url
                            userName:(NSString *)userName
                            password:(NSString *)password
                          completion:(void (^)(id response, NSError *error))block
{
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    [self requestGet:url paramaters:nil completion:block];
}

- (void)connectionChange:(void (^)(BOOL connected))block
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status > 0) {
            block(YES);
        } else {
            block(NO);
        }
    }];
}

- (BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
