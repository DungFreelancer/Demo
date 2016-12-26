//
//  MenuView.m
//  HAI
//
//  Created by Dung Do on 10/29/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "CALayer+BorderShadow.h"
#import "UtilityClass.h"
#import "CheckInViewModel.h"
#import "Constant.h"
#import <Firebase.h>

@implementation MenuView {
    NSArray<NSString *> *function;
    int encount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup table view.
    self.tblMenu.dataSource = self;
    self.tblMenu.delegate = self;
    self.tblMenu.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    
    [self setBanner];
    
    // Get function list.
    function = [USER_DEFAULT objectForKey:PREF_FUNCTION];
//    function = [[NSArray alloc] initWithObjects:@"checkin", @"checkstaff", @"event", @"newfeed", @"products", @"setting", nil];
    
    [self registerPushNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Setup navigation bar.
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.barTintColor = [[self view] tintColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [[self view] tintColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)setBanner {
    // Banner's image.
    NSString *name = [NSString stringWithFormat:@"banner_%d", arc4random_uniform(7) + 1];
    UIImageView *imgBanner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [imgBanner setFrame:CGRectMake(0,
                                   0,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height / 3)];
    
    // Banner's title.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(32, imgBanner.frame.size.height - 70 - 16, 70, 70)];
    title.text = @"HAI";
    title.font = [UIFont systemFontOfSize:50];
    title.numberOfLines = 1;
    title.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 10.0f/12.0f;
    title.clipsToBounds = YES;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentLeft;
    
    [imgBanner addSubview:title];
    [self.tblMenu setTableHeaderView:imgBanner];
}

- (void)registerPushNotification {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    // Get firebase token.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    if (refreshedToken == nil) {
        ELOG(@"Refreshed Token is:%@", refreshedToken);
        return;
    } else {
        DLOG(@"Refreshed Token is:%@", refreshedToken);
    }
    
    // Send token to service.
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    [params setObject:refreshedToken forKey:PARAM_REG_ID];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_UPDATE_REG paramaters:params completion:^(id response, NSError *error) {
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            
            // Show encount on event cell.
            encount = [[response valueForKey:RESPONSE_ECOUNT] intValue];
            [self.tblMenu reloadData];
            
            // Subscribe all topic.
            NSArray<NSString *> *arrtopic = [response valueForKey:RESPONSE_TOPICS];
            [USER_DEFAULT setObject:arrtopic forKey:PREF_TOPICS];
            for (NSString *topic in arrtopic) {
                NSString *name = [NSString stringWithFormat:@"/topics/%@", topic];
                [[FIRMessaging messaging] subscribeToTopic:name];
            }
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE]
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

// MARK: - Change Status's color
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// MARK: - UItableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return function.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == function.count - 1) {
        // Move setting to bottom of table.
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:function[0]];
        return cell;
    } else if ([function[indexPath.row + 1] isEqualToString:@"event"]) {
        // Set badge number to event.
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:function[indexPath.row + 1]];
        cell.lbBadgeNumber.text = [NSString stringWithFormat:@"%d", encount];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:function[indexPath.row + 1]];
        return cell;
    }
}

@end
