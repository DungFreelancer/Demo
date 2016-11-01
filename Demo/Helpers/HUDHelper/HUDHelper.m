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
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:self.hud];
    
    if (title == nil || [title isEqualToString:@""]) {
        self.hud.label.text = @"Loading...";
    } else {
        self.hud.label.text = title;
    }
    
    [self.hud showAnimated:TRUE];
}

- (void) hideLoading
{
    [self.hud hideAnimated:TRUE];
}

- (void)showToastWithMessage:(NSString *)message onView:(UIView *)view
{
    self.hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:self.hud];
    
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabel.text = message;
    self.hud.margin = 10.f;
    [self.hud setOffset:CGPointMake(0, 150.f)];
    [self.hud showAnimated:TRUE];
    [self.hud hideAnimated:TRUE afterDelay:3.5];
}

@end
