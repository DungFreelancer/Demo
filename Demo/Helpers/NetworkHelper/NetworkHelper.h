//
//  AFHelper.h
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Reachability/Reachability.h>

typedef void (^CompletionBlock)(id response, NSError *error);
typedef void (^StatusBlock)(BOOL connected);

@interface NetworkHelper : NSObject

@property(nonatomic,strong) AFHTTPSessionManager *manager;

+ (NetworkHelper *)sharedInstance;
- (void)requestGet:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(CompletionBlock)block;
- (void)setBasicAuthorizationWithUserName:(NSString *)userName password:(NSString *)password;
- (void)connectionChange:(StatusBlock)block;
- (BOOL)isConnected;

@end
