//
//  Login.m
//  HAI
//
//  Created by Dung Do on 10/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "LoginView.h"
#import "SupportViewModel.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "CALayer+BorderShadow.h"
#import "UtilityClass.h"
#import "Constant.h"
#import "CheckInViewModel.h"
#import "NewfeedViewModel.h"

@implementation LoginView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar.
    self.navigationController.navigationBarHidden = YES;
    
    // Setup button.
    [self.btnLogin.layer setShadowWithRadius:1.0f];
    [self.btnLogin.layer setBorderWithColor:self.btnLogin.tintColor.CGColor];
    
    self.txtUserName.delegate = self;
    self.txtPassword.delegate = self;
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    // Check login status.
    [self checkLoginStatus];
    
    // Template input
//    [self.txtUserName setText:@"hai"];
//    [self.txtPassword setText:@"123456"];
//    [self onClickLogin:nil];
}

- (IBAction)onClickLogin:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    NSString *userName = self.txtUserName.text;
    NSString *password = self.txtPassword.text;
    [[NetworkHelper sharedInstance] requestGetBasicAuthorization:API_LOGIN userName:userName password:password completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            NSString *token = [response valueForKey:RESPONSE_TOKEN];
            NSArray<NSString *> *function = [response valueForKey:RESPONSE_FUNCTION];
            NSString *role = [response valueForKey:RESPONSE_ROLE];
            
            // Check session.
            NSString *url = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", API_LOGIN_SESSION, PARAM_USER, userName, PARAM_TOKEN, token];
            [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
            
            [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
                
                [[HUDHelper sharedInstance] hideLoading];
                if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                    DLOG(@"%@", response);
                    [self performSegueWithIdentifier:@"segue_menu" sender:nil];
                    [self cleanAllView];
                    
                    // Check with old user login.
                    if ([userName isEqualToString:[USER_DEFAULT objectForKey:PREF_USER]] == NO) {
                        [self clearAllUserLog];
                    }
                    
                    // Save user information.
                    [USER_DEFAULT setBool:YES forKey:PREF_ALRAEDY_LOGIN];
                    [USER_DEFAULT setObject:userName forKey:PREF_USER];
                    [USER_DEFAULT setObject:token forKey:PREF_TOKEN];
                    [USER_DEFAULT setObject:function forKey:PREF_FUNCTION];
                    [USER_DEFAULT setObject:role forKey:PREF_ROLE];
                    [USER_DEFAULT synchronize];
                } else {
                    ELOG(@"%@", response);
                    [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                                   withTitle:NSLocalizedString(@"ERROR", nil)
                                                                  andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"LOGIN_SESSION", nil)
                                                                   andButton:NSLocalizedString(@"OK", nil)];
                }
            }];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"LOGIN_INCORRECT", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (void)checkLoginStatus {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    BOOL alreadyLogin = [USER_DEFAULT boolForKey:PREF_ALRAEDY_LOGIN];
    NSString *userName = [USER_DEFAULT valueForKey:PREF_USER];
    NSString *token = [USER_DEFAULT valueForKey:RESPONSE_TOKEN];
    
    if (alreadyLogin) {
        // Check session.
        NSString *url = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", API_LOGIN_SESSION, PARAM_USER, userName, PARAM_TOKEN, token];
        [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
        
        [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
            
            [[HUDHelper sharedInstance] hideLoading];
            if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                DLOG(@"%@", response);
                [self performSegueWithIdentifier:@"segue_menu" sender:nil];
            } else {
                ELOG(@"%@", response);
                [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                               withTitle:NSLocalizedString(@"ERROR", nil)
                                                              andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"LOGIN_SESSION", nil)
                                                               andButton:NSLocalizedString(@"OK", nil)];
                [USER_DEFAULT setBool:NO forKey:PREF_ALRAEDY_LOGIN];
                [USER_DEFAULT synchronize];
            }
        }];
    }
}

- (void)cleanAllView {
    self.txtUserName.text = @"";
    self.txtPassword.text = @"";
}

- (void)clearAllUserLog {
    CheckInViewModel *vmCheckIn = [[CheckInViewModel alloc] init];
    [vmCheckIn clearCheckIns];
    
    SupportViewModel *vmSupport = [[SupportViewModel alloc] init];
    [vmSupport clearSupports];
    
    NewfeedViewModel *vmNewfeed = [[NewfeedViewModel alloc] init];
    [vmNewfeed clearNewfeeds];
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtUserName) {
        [self.txtUserName resignFirstResponder];
        [self.txtPassword becomeFirstResponder];
    } else if (textField == self.txtPassword) {
        [self.txtPassword resignFirstResponder];
        [self onClickLogin:nil];
    }
    
    return YES;
}

// MARK: - UIGestureRecognizerDelegate
-(void)handleSingleTapGesture {
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

@end
