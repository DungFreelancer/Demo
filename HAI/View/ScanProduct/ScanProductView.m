//
//  ScanProductView.m
//  HAI
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "ScanProductView.h"
#import <MTBBarcodeScanner/MTBBarcodeScanner.h>
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation ScanProductView {
    MTBBarcodeScanner *scanner;
    BOOL isStop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbCode.dataSource = self;
    self.tbCode.delegate = self;
    self.tbCode.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    
    self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.arrCodes.count];
    
    // Setup for buttons & text view.
    [self.btnStop.layer setShadowWithRadius:1.0f];
    [self.btnStop.layer setBorderWithColor:self.btnStop.tintColor.CGColor];
    
    scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.viewScan];
    isStop = NO;
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                [scanner freezeCapture];
//                [scanner stopScanning]; // Hide the scan view
                
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                if ([code.stringValue isEqualToString:self.arrCodes.lastObject] == NO) {
                    [self.arrCodes addObject:code.stringValue];
                    self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.arrCodes.count];
                    
                    [self.tbCode reloadData];
                    [super scrollToBottomOnTableView:self.tbCode];
                }
                
                [scanner unfreezeCapture];
            } error:&error];
            
        } else {
            // The user denied access to the camera
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:nil
                                                          andMessage:NSLocalizedString(@"NO_CAMERA", nil)
                                                       andMainButton:NSLocalizedString(@"OK", nil)
                                                   CompletionHandler:^(UIAlertAction *action) {
                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                   }
                                                      andOtherButton:nil
                                                   CompletionHandler:nil];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.delegate didScanProducts:self.arrCodes];
}

- (IBAction)onClickStop:(id)sender {
    if (!isStop) {
        [scanner freezeCapture];
        isStop = YES;
        [self.btnStop setTitle:@"QUÉT TIẾP" forState:UIControlStateNormal];
    } else {
        [scanner unfreezeCapture];
        isStop = NO;
        [self.btnStop setTitle:@"DỪNG QUÉT" forState:UIControlStateNormal];
    }
}

// MARK: - UITableViewDataSource & UItableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"code_cell" forIndexPath:indexPath];
    cell.textLabel.text = self.arrCodes[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.arrCodes removeObjectAtIndex:indexPath.row];
        [self.tbCode reloadData];
    }
}

@end
