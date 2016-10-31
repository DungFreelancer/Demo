//
//  AFHelper.h
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Reachability/Reachability.h>

#ifndef COMPLETION_BLOCK
#define COMPLETION_BLOCK
typedef void (^CompletionBlock)(id response, NSError *error);
#endif

#ifndef STATUS_BLOCK
#define STATUS_BLOCK
typedef void (^StatusBlock)(BOOL connected);
#endif

@interface NetworkHelper : NSObject

@property(nonatomic,strong) AFHTTPSessionManager *manager;

+ (NetworkHelper *)sharedInstance;
- (void)requestGet:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(CompletionBlock)block;
- (void)requestGetBasicAuthorization:(NSString *)url userName:(NSString *)userName password:(NSString *)password completion:(CompletionBlock)block;
- (void)connectionChange:(StatusBlock)block;
- (BOOL)isConnected;

@end
