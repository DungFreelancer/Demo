//
//  CheckInView.m
//  Demo
//
//  Created by Dung Do on 11/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SettingView.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "HUDHelper.h"
#import "CheckInViewModel.h"
#import "Constant.h"

@implementation SettingView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
}


// MARK: - UITextFieldDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self logoutApp];
        } else if (indexPath.row == 1) {
            
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        }
    }
}

- (void)logoutApp {
    if ([[NetworkHelper sharedInstance]  isConnected] == false) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    CheckInViewModel *ciViewModel = [[CheckInViewModel alloc] init];
    
    if ([ciViewModel numberOfUnsended] > 0) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:nil
                                                      andMessage:NSLocalizedString(@"SETTING_WARRNING", nil)
                                                   andMainButton:NSLocalizedString(@"NO", nil)
                                               CompletionHandler:nil
                                                  andOtherButton:NSLocalizedString(@"YES", nil)
                                               CompletionHandler:^(UIAlertAction *action) {
                                                   [self logoutUser];
                                               }];
        
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:nil
                                                      andMessage:NSLocalizedString(@"SETTING_LOGOUT", nil)
                                                   andMainButton:NSLocalizedString(@"NO", nil)
                                               CompletionHandler:nil
                                                  andOtherButton:NSLocalizedString(@"YES", nil)
                                               CompletionHandler:^(UIAlertAction *action) {
                                                   [self logoutUser];
                                               }];
    }
}

- (void)logoutUser {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_LOGOUT paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            [USER_DEFAULT setBool:NO forKey:PREF_ALRAEDY_LOGIN];
            [USER_DEFAULT synchronize];
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:NSLocalizedString(@"SETTING_LOGOUT_ERROR", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (void)setBackBarItem {
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 25, 25);
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.hidesBackButton = YES;
}

- (void)onClickBackBarItem:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

@end
