//
//  MenuView.m
//  Demo
//
//  Created by Dung Do on 10/29/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "MenuView.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "CALayer+BorderShadow.h"
#import "UtilityClass.h"
#import "CheckInViewModel.h"
#import "Constant.h"

@implementation MenuView {
    NSArray<NSString *> *function;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [[self view] tintColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [[self view] tintColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Setup table view.
    self.tblMenu.dataSource = self;
    self.tblMenu.delegate = self;
    
    // Get function list.
    function = [USER_DEFAULT objectForKey:PREF_FUNCTION];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return function.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:function[indexPath.row]];
    
    [cell.layer setShadowWithRadius:2.0f];
    
    return cell;
}

- (IBAction)onClickLogout:(id)sender {
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
                                                      andMessage:NSLocalizedString(@"CHECKIN_WARRNING", nil)
                                                   andMainButton:NSLocalizedString(@"CHECKIN_CANCEL", nil)
                                               CompletionHandler:nil
                                                  andOtherButton:NSLocalizedString(@"CHECKIN_DELETE", nil)
                                               CompletionHandler:^(UIAlertAction *action) {
                                                   
                                                   [ciViewModel clearCheckIns];
                                                   [self logoutUser];
                                               }];
        
    } else {
        [self logoutUser];
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
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:NSLocalizedString(@"LOGIN_LOGOUT", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

@end
