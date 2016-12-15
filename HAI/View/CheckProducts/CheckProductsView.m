//
//  CheckProductsView.m
//  HAI
//
//  Created by Dung Do on 11/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckProductsView.h"
#import "TrackingCell.h"
#import "CALayer+BorderShadow.h"
#import "HUDHelper.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation CheckProductsView {
    NSMutableArray<NSDictionary *> *arrTracking;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbTracking.dataSource = self;
    self.tbTracking.delegate = self;
    self.tbTracking.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    self.txtCode.delegate = self;
    [self.txtCode becomeFirstResponder];
    
    arrTracking = [[NSMutableArray alloc] init];
    
    // Setup button.
    [self.btnCheck.layer setShadowWithRadius:1.0f];
    [self.btnCheck.layer setBorderWithColor:self.btnCheck.tintColor.CGColor];
    
    [self.txtCode.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [singleTapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_scan_card"]) {
        ScanCardView *scv = [segue destinationViewController];
        scv.delegate = self;
    }
}

- (IBAction)onClickCheck:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    if ([self.txtCode.text isEqualToString:@""]) {
        ELOG(@"%@", NSLocalizedString(@"TRACKING_NO_CODE", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"TRACKING_NO_CODE", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    [params setObject:self.txtCode.text forKey:PARAM_CODE];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_TRACKING_PRODUCT paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            arrTracking = [response valueForKey:@"tracking"];
            [self.tbTracking reloadData];
            [self cleanAllView];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"PRODUCTS_ERROR", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (void)cleanAllView {
    [self.txtCode resignFirstResponder];
}

// MARK: - ScanCardViewDelegate
- (void)didScanCard:(NSString *)result {
    self.txtCode.text = result;
    [self onClickCheck:nil];
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickCheck:nil];
    
    return YES;
}

// MARK: - UIGestureRecognizerDelegate
- (void)handleSingleTapGesture {
    [self.txtCode resignFirstResponder];
}

// MARK: - UITable DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTracking.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackingCell *cell = (TrackingCell *) [tableView dequeueReusableCellWithIdentifier:@"tracking_cell" forIndexPath:indexPath];
    
    cell.lbName.text = [arrTracking[indexPath.row] valueForKey:@"name"];
    cell.lbImportTime.text = [arrTracking[indexPath.row]valueForKey:@"importTime"];
    cell.lbExportTime.text = [arrTracking[indexPath.row] valueForKey:@"exportTime"];
    
    return cell;
}

@end
