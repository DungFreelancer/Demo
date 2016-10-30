//
//  UIImage+Download.h
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompletionBlock)(BOOL success);

@interface UIImageView (Download)

- (void)downloadFromURL:(NSString *)url withPlaceholder:(UIImage *)placehold handleCompletion:(CompletionBlock)block;

@end
