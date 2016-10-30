//
//  UIImage+Download.m
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "UIImageView+Download.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation UIImageView (Download)

- (void)downloadFromURL:(NSString *)url withPlaceholder:(UIImage *)placehold handleCompletion:(CompletionBlock)block
{
    if (placehold) {
        [self setImage:placehold];
    }
    
    if (url) {
        UIActivityIndicatorView *ai=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((self.frame.size.width-37)/2, (self.frame.size.height-37)/2, 37, 37)];
        [ai setHidesWhenStopped:YES];
        ai.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
        [ai setTintColor:[UIColor redColor]];
        [self addSubview:ai];
        [ai startAnimating];
        
        if ([url rangeOfString:@"/Library/"].location != NSNotFound)
        {
            [ai stopAnimating];
            ai = nil;
            NSData *imageData=[NSData dataWithContentsOfFile:url];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                [self setImage:image];
                [self setNeedsLayout];
                imageData = nil;
            }
            block(YES);
            return;
        }
        
        NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
        NSString *strImgName = [[[url stringByAddingPercentEncodingWithAllowedCharacters:set] componentsSeparatedByString:@"/"] lastObject];
        
        AppDelegate *app = APP_DELEGATE;
        [app applicationCacheDirectoryString];
        
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",[app applicationCacheDirectoryString],strImgName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *aURL=[url stringByAddingPercentEncodingWithAllowedCharacters:set];
        
        if([strImgName isEqualToString:@"picture?type=large"])
        {
            [fileManager removeItemAtPath:imagePath error:nil];
        }
        
        if ([fileManager fileExistsAtPath:imagePath]==NO)
        {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^(void) {
                
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:aURL]];
                //[imageData writeToFile:imagePath atomically:YES];
                
                UIImage* image = [[UIImage alloc] initWithData:imageData];
                UIImage *imgUpload = [[UtilityClass sharedInstance]scaleAndRotateImage:image];
                NSData *dataS = UIImagePNGRepresentation(imgUpload);
                [dataS writeToFile:imagePath atomically:YES];
                
                imageData = nil;
                if (imgUpload) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ai stopAnimating];
                        [self setImage:imgUpload];
                        [self setNeedsLayout];
                        block(YES);
                    });
                }
                else
                {
                    [ai stopAnimating];
                    block(NO);
                }
            });
        }
        else{
            [ai stopAnimating];
            ai = nil;
            NSData *imageData=[NSData dataWithContentsOfFile:imagePath];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            if (image) {
                [self setImage:image];
                [self setNeedsLayout];
            }
            imageData = nil;
            block(YES);
        }
    }
}

@end
