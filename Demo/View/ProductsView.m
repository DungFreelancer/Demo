//
//  ProductsView.m
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "ProductsView.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "UtilityClass.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation ProductsView {
    NSDictionary *currentAgency;
    NSMutableArray *arrCodes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbCode.dataSource = self;
    self.tbCode.delegate = self;
    
    // Setup for buttons & text view.
    [self.btnScanProduct.layer setShadowWithRadius:1.0f];
    [self.btnScanProduct.layer setBorderWithColor:self.btnScanProduct.tintColor.CGColor];
    [self.btnUpdate.layer setShadowWithRadius:1.0f];
    [self.btnUpdate.layer setBorderWithColor:self.btnUpdate.tintColor.CGColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"agency"]) {
        AgencyView *viewAgency = (AgencyView *) [segue destinationViewController];
        viewAgency.delegate = self;
    } else if ([segue.identifier isEqualToString:@"scan_code"]) {
        ScanProductView *viewScanProduct = (ScanProductView *) [segue destinationViewController];
        viewScanProduct.delegate = self;
        
        if (arrCodes == nil) {
            arrCodes = [[NSMutableArray alloc] init];
        }
        viewScanProduct.arrCodes = arrCodes;
    }
}

- (IBAction)onClickUpdate:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == false) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    if (currentAgency == nil) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"PRODUCTS_AGENCY_ERROR", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    if (arrCodes == nil) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"PRODUCTS_PRODUCTS_ERROR", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSString *status;
    if ([self.segStatus selectedSegmentIndex] == 0) {
        status = @"NK";
    } else {
        status = @"XK";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    [params setObject:arrCodes forKey:PARAM_PRODUCTS];
    [params setObject:[currentAgency valueForKey:@"id"] forKey:PARAM_AGENCY];
    [params setObject:status forKey:PARAM_STATUS];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_UPDATE_PRODUCT paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:nil
                                                          andMessage:NSLocalizedString(@"PRODUCTS_UPDATED", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
            [self cleanAllView];
        } else {
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:NSLocalizedString(@"PRODUCTS_ERROR", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (void)cleanAllView {
    [self.segStatus setSelectedSegmentIndex:0];
    self.lbTotal.text = @"";
    arrCodes = [[NSMutableArray alloc] init];
    [self.tbCode reloadData];
}

// MARK: - AgencyViewDelegate
- (void)didGetAgency:(NSDictionary *)agency {
    currentAgency = agency;
    self.lbAgency.text = [currentAgency valueForKey:@"store"];
}

// MARK: - ScanProductViewDelegate
- (void)didScanProducts:(NSMutableArray *)result {
    arrCodes = result;
    [self.tbCode reloadData];
    
    self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrCodes.count];
}

// MARK: - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"code_cell" forIndexPath:indexPath];
    cell.textLabel.text = arrCodes[indexPath.row];
    
    return cell;
}

@end
