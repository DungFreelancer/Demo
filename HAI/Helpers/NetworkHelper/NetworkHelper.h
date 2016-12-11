//
//  AFHelper.h
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Reachability/Reachability.h>

@interface NetworkHelper : NSObject

@property(nonatomic,strong) AFHTTPSessionManager *manager;

+ (NetworkHelper *)sharedInstance;

- (void)requestGet:(NSString *)url
        paramaters:(NSMutableDictionary *)paramaters
        completion:(void (^)(id response, NSError *error))block;

- (void)requestPost:(NSString *)url
         paramaters:(NSMutableDictionary *)paramaters
         completion:(void (^)(id response, NSError *error))block;

- (void)requestPost:(NSString *)url
         paramaters:(NSMutableDictionary *)paramaters
              image:(UIImage *)image
         completion:(void (^)(id response, NSError *error))block;

- (void)requestGetBasicAuthorization:(NSString *)url
                            userName:(NSString *)userName
                            password:(NSString *)password
                          completion:(void (^)(id response, NSError *error))block;

- (void)connectionChange:(void (^)(BOOL connected))block;

- (BOOL)isConnected;

@end
