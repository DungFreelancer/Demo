//
//  SaveProductsView.m
//  Demo
//
//  Created by Dung Do on 11/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SaveProductsView.h"
#import "ScanCardView.h"
#import "CALayer+BorderShadow.h"
#import "HUDHelper.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation SaveProductsView {
    NSMutableArray<NSString *> *arrCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbCodes.dataSource = self;
    self.tbCodes.delegate = self;
    self.txtCode.delegate = self;
    
    arrCode = [[NSMutableArray alloc] init];
    
    // Setup button.
    [self.btnScan.layer setShadowWithRadius:1.0f];
    [self.btnScan.layer setBorderWithColor:self.btnScan.tintColor.CGColor];
    [self.btnSend.layer setShadowWithRadius:1.0f];
    [self.btnSend.layer setBorderWithColor:self.btnSend.tintColor.CGColor];
    [self.btnAdd.layer setShadowWithRadius:1.0f];
    [self.btnAdd.layer setBorderWithColor:self.btnAdd.tintColor.CGColor];
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [singleTapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tbCodes reloadData]; // Reload table after scan code.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_scan_card"]) {
        ScanCardView *scv = [segue destinationViewController];
        scv.arrCodes = arrCode;
    }
}

- (IBAction)onClickAdd:(id)sender {
    if ([self.txtCode.text isEqualToString:@""] == NO &&
        [self.txtCode.text isEqualToString:arrCode.lastObject] == NO) {
        [arrCode addObject:self.txtCode.text];
        self.txtCode.text = @"";
        
        [self.tbCodes reloadData];
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"PRODUCTS_NILL", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
    }
}

- (IBAction)onClickSend:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    if (arrCode.count == 0) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"PRODUCTS_COUNT_ERROR", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    [params setObject:arrCode forKey:PARAM_CODES];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_SAVE_PRODUCT paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            
            [arrCode removeAllObjects];
            for (NSString *code in [response valueForKey:RESPONSE_CODES]) {
                [arrCode addObject:code];
            }
            
            if (arrCode.count > 0) {
                [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                               withTitle:nil
                                                              andMessage:[NSString stringWithFormat:NSLocalizedString(@"PRODUCTS_DUPLICATE", nil), arrCode.count]
                                                               andButton:NSLocalizedString(@"OK", nil)];
                [self.tbCodes reloadData];
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

- (void)cleanAllView {
    self.txtCode.text = @"";
    [self.txtCode resignFirstResponder];
    [arrCode removeAllObjects];
    [self.tbCodes reloadData];
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.txtCode.text isEqualToString:@""] == NO &&
        [self.txtCode.text isEqualToString:arrCode.lastObject] == NO) {
        [arrCode addObject:textField.text];
        textField.text = @"";
        
        [self.tbCodes reloadData];
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"PRODUCTS_NILL", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
    }
    
    return YES;
}

// MARK: - UIGestureRecognizerDelegate
- (void)handleSingleTapGesture {
    [self.txtCode resignFirstResponder];
}

// MARK: - UITable DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCode.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"code_cell" forIndexPath:indexPath];
    cell.textLabel.text = arrCode[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [arrCode removeObjectAtIndex:indexPath.row];
        [self.tbCodes reloadData];
    }
}

@end