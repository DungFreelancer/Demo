//
//  MBProgressHUD+Title.m
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "HUDHelper.h"

@implementation HUDHelper

@synthesize hud;

+ (HUDHelper *)sharedInstance {
    static HUDHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HUDHelper alloc] init];
    });
    return instance;
}

- (void) showLoadingWithTitle:(nonnull NSString *)title onView:(UIView *)view
{
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hud];
    }
    
    if (title == nil || [title isEqualToString:@""]) {
        hud.label.text = @"Loading...";
    } else {
        hud.label.text = title;
    }
    
    [hud showAnimated:TRUE];
}

- (void) hideLoading
{
    [hud hideAnimated:TRUE];
}

- (void)showToastWithMessage:(NSString *)message onView:(UIView *)view
{
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hud];
    }
    
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.margin = 10.f;
    [hud setOffset:CGPointMake(0, 150.f)];
    [hud showAnimated:TRUE];
    [hud hideAnimated:TRUE afterDelay:3.5];
}

@end
