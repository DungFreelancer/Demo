//
//  MBProgressHUD+Title.h
//  HAI
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface HUDHelper : NSObject

@property(nonatomic, strong) MBProgressHUD *hud;

+ (HUDHelper *)sharedInstance;
- (void)showLoadingWithTitle:(NSString *)title onView:(UIView *)view;
- (void)hideLoading;
- (void)showToastWithMessage:(NSString *)message onView:(UIView *)view;

@end
