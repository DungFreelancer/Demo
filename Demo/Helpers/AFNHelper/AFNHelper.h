//
//  AFHelper.h
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

#define POST_METHOD @"POST"
#define GET_METHOD  @"GET"

typedef void (^CompletionBlock)(id response, NSError *error);
typedef void (^StatusBlock)(BOOL connected);

@interface AFNHelper : NSObject

@property(nonatomic,strong) AFHTTPSessionManager *manager;

+ (AFNHelper *)sharedInstance;
- (void)request:(NSString *)url method:(NSString *)method paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)request:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(CompletionBlock)block;
- (void)connectionChange:(StatusBlock)block;

@end
