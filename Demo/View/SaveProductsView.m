//
//  SaveProductsView.m
//  Demo
//
//  Created by Dung Do on 11/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SaveProductsView.h"
#import "CALayer+BorderShadow.h"
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

- (IBAction)onClickSend:(id)sender {
    
}

// MARK: - ScanCardViewDelegate
- (void)didScanCard:(NSString *)result {
    
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.txtCode.text isEqualToString:@""] == NO &&
        [self.txtCode.text isEqualToString:arrCode.lastObject] == NO) {
        [arrCode addObject:textField.text];
        textField.text = @"";
        
        [self.tbCodes reloadData];
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

@end
