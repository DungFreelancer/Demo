//
//  AFHelper.h
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Reachability/Reachability.h>

typedef void (^NetworkHelperBlock)(id response, NSError *error);
typedef void (^NetworkHelperStatus)(BOOL connected);

@interface NetworkHelper : NSObject

@property(nonatomic,strong) AFHTTPSessionManager *manager;

+ (NetworkHelper *)sharedInstance;
- (void)requestGet:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(NetworkHelperBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(NetworkHelperBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(NetworkHelperBlock)block;
- (void)requestGetBasicAuthorization:(NSString *)url userName:(NSString *)userName password:(NSString *)password completion:(NetworkHelperBlock)block;
- (void)connectionChange:(NetworkHelperStatus)block;
- (BOOL)isConnected;

@end
