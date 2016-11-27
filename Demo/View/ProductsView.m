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
    NSMutableArray *arrCodes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbCode.dataSource = self;
    self.tbCode.delegate = self;
    self.txtCode.delegate = self;
    
    arrCodes = [[NSMutableArray alloc] init];
    
    // Setup for buttons & text view.
    [self.btnScanProduct.layer setShadowWithRadius:1.0f];
    [self.btnScanProduct.layer setBorderWithColor:self.btnScanProduct.tintColor.CGColor];
    [self.btnUpdate.layer setShadowWithRadius:1.0f];
    [self.btnUpdate.layer setBorderWithColor:self.btnUpdate.tintColor.CGColor];
    [self.btnSave.layer setShadowWithRadius:1.0f];
    [self.btnSave.layer setBorderWithColor:self.btnSave.tintColor.CGColor];
    [self.txtCode.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"scan_code"]) {
        ScanProductView *viewScanProduct = (ScanProductView *) [segue destinationViewController];
        viewScanProduct.delegate = self;
        
        viewScanProduct.arrCodes = arrCodes;
    }
}

- (IBAction)onClickUpdate:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
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
    [params setObject:status forKey:PARAM_STATUS];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_UPDATE_PRODUCT paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:nil
                                                          andMessage:NSLocalizedString(@"PRODUCTS_UPDATED", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
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

- (IBAction)onClickSave:(id)sender {
    if ([self.txtCode.text isEqualToString:@""] == NO &&
        [self.txtCode.text isEqualToString:arrCodes.lastObject] == NO) {
        [arrCodes addObject:self.txtCode.text];
        self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrCodes.count];
        self.txtCode.text = @"";
        
        [self.tbCode reloadData];
    }
    
    [self.txtCode resignFirstResponder];
}

- (void)cleanAllView {
    [self.segStatus setSelectedSegmentIndex:0];
    self.lbTotal.text = @"0";
    self.txtCode.text = @"";
    arrCodes = [[NSMutableArray alloc] init];
    [self.tbCode reloadData];
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

// MARK: - UIGestureRecognizerDelegate
- (void)handleSingleTapGesture {
    [self.txtCode resignFirstResponder];
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickSave:nil];
    
    return YES;
}

@end
