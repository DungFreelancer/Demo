//
//  AFHelper.h
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^CompletionBlock)(id response, NSError *error);
typedef void (^StatusBlock)(BOOL connected);

@interface AFNHelper : NSObject

@property(nonatomic,strong) AFHTTPSessionManager *manager;

+ (AFNHelper *)sharedInstance;
- (void)requestGet:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)requestPost:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(CompletionBlock)block;
- (void)connectionChange:(StatusBlock)block;

@end
