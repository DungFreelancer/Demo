//
//  IEProductsView.m
//  HAI
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "IEProductsView.h"
#import "IEProductsCell.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "UtilityClass.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation ProductsView {
    NSMutableArray *arrCodes;
    bool isCodesRespone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbCode.dataSource = self;
    self.tbCode.delegate = self;
    self.tbCode.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    self.txtCode.delegate = self;
    self.txtReceiver.delegate = self;
    
    arrCodes = [[NSMutableArray alloc] init];
    isCodesRespone = NO;
    
    // Setup for buttons & text view.
    [self.btnScanProduct.layer setShadowWithRadius:1.0f];
    [self.btnScanProduct.layer setBorderWithColor:self.btnScanProduct.tintColor.CGColor];
    [self.btnUpdate.layer setShadowWithRadius:1.0f];
    [self.btnUpdate.layer setBorderWithColor:self.btnUpdate.tintColor.CGColor];
    [self.txtReceiver.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    [self.txtCode.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    
    [self.lbReceiver setHidden:YES];
    [self.txtReceiver setHidden:YES];
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"scan_code"]) {
        if (isCodesRespone) {
            isCodesRespone = NO;
            [arrCodes removeAllObjects];
        }
        
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
    
    if (arrCodes.count == 0) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"PRODUCTS_COUNT_ERROR", nil)
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
    [params setObject:self.txtReceiver.text forKey:PARAM_RECEIVER];
    [params setObject:arrCodes forKey:PARAM_PRODUCTS];
    [params setObject:status forKey:PARAM_STATUS];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_UPDATE_PRODUCT paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            
            [arrCodes removeAllObjects];
            for (NSString *code in [response valueForKey:RESPONSE_PRODUCTS]) {
                [arrCodes addObject:code];
            }
            
            if (arrCodes.count > 0) {
                [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                               withTitle:nil
                                                              andMessage:[NSString stringWithFormat:NSLocalizedString(@"PRODUCTS_DUPLICATE", nil), arrCodes.count]
                                                               andButton:NSLocalizedString(@"OK", nil)];
                self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrCodes.count];
                
                isCodesRespone = YES;
                [self.tbCode reloadData];
                [self scrollToNewCell];
            } else {
                [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                               withTitle:nil
                                                              andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"PRODUCTS_UPDATED", nil)
                                                               andButton:NSLocalizedString(@"OK", nil)];
                [self cleanAllView];
            }
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"PRODUCTS_ERROR", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (IBAction)onClickStatus:(id)sender {
    if ([self.segStatus selectedSegmentIndex] == 0) {
        [self.lbReceiver setHidden:YES];
        [self.txtReceiver setHidden:YES];
    } else {
        [self.lbReceiver setHidden:NO];
        [self.txtReceiver setHidden:NO];
    }
}

- (IBAction)onClickSave:(id)sender {
    if ([self.txtCode.text isEqualToString:@""] == NO &&
        [self.txtCode.text isEqualToString:arrCodes.lastObject] == NO) {
        [arrCodes addObject:self.txtCode.text];
        self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrCodes.count];
        self.txtCode.text = @"";
        
        [self.tbCode reloadData];
        [self scrollToNewCell];
    }
}

- (void)cleanAllView {
    [self.segStatus setSelectedSegmentIndex:0];
    self.lbTotal.text = @"0";
    self.txtCode.text = @"";
    [self.txtCode resignFirstResponder];
    [arrCodes removeAllObjects];
    [self.tbCode reloadData];
}

- (void)scrollToNewCell {
    NSInteger lastSection = self.tbCode.numberOfSections - 1;
    NSInteger lastRow = [self.tbCode numberOfRowsInSection:lastSection] - 1;
    if (lastRow < 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
    [self.tbCode scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

// MARK: - ScanProductViewDelegate
- (void)didScanProducts:(NSMutableArray *)result {
    arrCodes = result;
    [self.tbCode reloadData];
    [self scrollToNewCell];
    
    self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrCodes.count];
}

// MARK: - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isCodesRespone) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"code_cell_1" forIndexPath:indexPath];
        cell.textLabel.text = arrCodes[indexPath.row];
        
        return cell;
    } else {
        IEProductsCell *cell = (IEProductsCell *) [tableView dequeueReusableCellWithIdentifier:@"code_cell_2" forIndexPath:indexPath];
        cell.lbCode.text = [arrCodes[indexPath.row] valueForKey:@"code"];
        cell.lbName.text = [arrCodes[indexPath.row] valueForKey:@"name"];
        cell.lbStatus.text = [arrCodes[indexPath.row] valueForKey:@"status"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arrCodes removeObjectAtIndex:indexPath.row];
        [self.tbCode reloadData];
    }
}

// MARK: - UIGestureRecognizerDelegate
- (void)handleSingleTapGesture {
    [self.txtReceiver resignFirstResponder];
    [self.txtCode resignFirstResponder];
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtReceiver) {
        [self.txtCode becomeFirstResponder];
    } else if (textField == self.txtCode) {
        if (isCodesRespone) {
            isCodesRespone = NO;
            [arrCodes removeAllObjects];
        }
        
        [self onClickSave:nil];
    }
    
    return YES;
}

@end
