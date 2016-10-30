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
#import "CALayer+BorderShadow.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation LoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar.
    self.navigationController.navigationBarHidden = YES;
    
    // Setup button.
    [self.btnLogin.layer setShadowWithRadius:1.0f];
    [self.btnLogin.layer setBorderWithColor:self.btnLogin.tintColor.CGColor];
    
    // Template input
    [self.txtUserName setText:@"namlh"];
    [self.txtPassword setText:@"123456"];
    [self onClickLogin:nil];
}

- (IBAction)onClickLogin:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == false) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSString *userName = self.txtUserName.text;
    NSString *password = self.txtPassword.text;
    [[NetworkHelper sharedInstance] setBasicAuthorizationWithUserName:userName password:password];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestGet:API_LOGIN paramaters:nil completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        if ([[response valueForKey:RESPONE_ID] isEqualToString:@"1"]) {
            NSString *token = [response valueForKey:RESPONE_TOKEN];
            NSArray<NSString *> *function = [response valueForKey:RESPONE_FUNCTION];
            
            // Check session.
            NSString *url = [NSString stringWithFormat:@"%@?user=%@&token=%@", API_LOGIN_SESSION, userName, token];
            [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
            
            [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
                
                [[HUDHelper sharedInstance] hideLoading];
                if ([[response valueForKey:RESPONE_ID] isEqualToString:@"1"]) {
                    [self performSegueWithIdentifier:@"segue_menu" sender:nil];
                    
                    // Save user information.
                    [USER_DEFAULT setObject:userName forKey:PREF_USER];
                    [USER_DEFAULT setObject:token forKey:PREF_TOKEN];
                    [USER_DEFAULT setObject:function forKey:PREF_FUNCTION];
                    [USER_DEFAULT synchronize];
                } else {
                    [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                                   withTitle:NSLocalizedString(@"ERROR", nil)
                                                                  andMessage:NSLocalizedString(@"LOGIN_SESSION", nil)
                                                                   andButton:NSLocalizedString(@"OK", nil)];
                }
            }];
        } else {
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:NSLocalizedString(@"LOGIN_INCORRECT", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

@end
