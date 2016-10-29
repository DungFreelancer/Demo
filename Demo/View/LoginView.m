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
            [USER_DEFAULT setObject:[response valueForKey:RESPONE_USER] forKey:PREF_USER];
            [USER_DEFAULT setObject:[response valueForKey:RESPONE_TOKEN] forKey:PREF_TOKEN];
            
            // Check session.
            NSString *url = [NSString stringWithFormat:@"%@?user=%@&token=%@", API_LOGIN_SESSION, [USER_DEFAULT valueForKey:PREF_USER], [USER_DEFAULT valueForKey:PREF_TOKEN]];
            [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
            
            [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
                
                [[HUDHelper sharedInstance] hideLoading];
                if ([[response valueForKey:RESPONE_ID] isEqualToString:@"1"]) {
                    [self performSegueWithIdentifier:@"segue_main" sender:nil];
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
