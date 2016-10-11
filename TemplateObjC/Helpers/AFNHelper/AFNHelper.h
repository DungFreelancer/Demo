//
//  AFNHelper.h
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define POST_METHOD @"POST"
#define GET_METHOD  @"GET"

typedef void (^CompletionBlock)(id response, NSError *error);

@interface AFNHelper : NSObject
{
    CompletionBlock dataBlock;
}

+ (AFNHelper *)sharedInstance;
- (void)request:(NSString *)url method:(NSString *)method paramaters:(NSMutableDictionary *)paramaters completion:(CompletionBlock)block;
- (void)request:(NSString *)url paramaters:(NSMutableDictionary *)paramaters image:(UIImage *)image completion:(CompletionBlock)block;

@end
