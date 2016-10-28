//
//  Login.m
//  Demo
//
//  Created by Dung Do on 10/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "LoginView.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation LoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Template input
    [self.txtUserName setText:@"namlh"];
    [self.txtPassword setText:@"123456"];
}

- (IBAction)onClickLogin:(id)sender {
    NSString *userName = self.txtUserName.text;
    NSString *password = self.txtPassword.text;
    [[NetworkHelper sharedInstance] setBasicAuthorizationWithUserName:userName password:password];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:@"Đang xử lý..." onView:self.view];
    
    [[NetworkHelper sharedInstance] requestGet:API_LOGIN paramaters:nil completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        if ([[response valueForKey:RESPONE_ID] isEqualToString:@"1"]) {
            [USER_DEFAULT setObject:[response valueForKey:RESPONE_USER] forKey:PREF_USER];
            [USER_DEFAULT setObject:[response valueForKey:RESPONE_TOKEN] forKey:PREF_TOKEN];
            
            // Check session.
            NSString *url = [NSString stringWithFormat:@"%@?user=%@&token=%@", API_LOGIN_SESSION, [USER_DEFAULT valueForKey:PREF_USER], [USER_DEFAULT valueForKey:PREF_TOKEN]];
            [[HUDHelper sharedInstance] showLoadingWithTitle:@"Đang xử lý..." onView:self.view];
            
            [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
                
                [[HUDHelper sharedInstance] hideLoading];
                if ([[response valueForKey:RESPONE_ID] isEqualToString:@"1"]) {
                    [self performSegueWithIdentifier:@"segue_main" sender:nil];
                } else {
                    [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:@"Lỗi" andMessage:@"Tài khoản đang được đăng nhập trên máy khác" andButton:@"OK"];
                }
            }];
        } else {
            [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:@"Lỗi" andMessage:@"Tài khoản hoặc mật khẩu không chính xác" andButton:@"OK"];
        }
    }];
}
@end
