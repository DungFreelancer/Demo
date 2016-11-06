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
    
    self.txtUserName.delegate = self;
    self.txtPassword.delegate = self;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    // Template input
//    [self.txtUserName setText:@"test"];
//    [self.txtPassword setText:@"123456"];
//    [self onClickLogin:nil];
}

- (IBAction)onClickLogin:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == false) {
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
            NSString *token = [response valueForKey:RESPONSE_TOKEN];
            NSArray<NSString *> *function = [response valueForKey:RESPONSE_FUNCTION];
            NSString *role = [response valueForKey:RESPONSE_ROLE];
            
            // Check session.
            NSString *url = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", API_LOGIN_SESSION, PARAM_USER, userName, PARAM_TOKEN, token];
            [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
            
            [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
                
                [[HUDHelper sharedInstance] hideLoading];
                if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                    [self performSegueWithIdentifier:@"segue_menu" sender:nil];
                    [self cleanAllView];
                    
                    // Save user information.
                    [USER_DEFAULT setObject:userName forKey:PREF_USER];
                    [USER_DEFAULT setObject:token forKey:PREF_TOKEN];
                    [USER_DEFAULT setObject:function forKey:PREF_FUNCTION];
                    [USER_DEFAULT setObject:role forKey:PREF_ROLE];
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

- (void)cleanAllView {
    self.txtUserName.text = @"";
    self.txtPassword.text = @"";
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
    
    return true;
}

// MARK: - UIGestureRecognizerDelegate
-(void)handleSingleTapGesture {
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

@end
