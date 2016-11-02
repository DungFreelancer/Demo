//
//  ScanCardView.m
//  Demo
//
//  Created by Dung Do on 10/11/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "ScanCardView.h"
#import <MTBBarcodeScanner/MTBBarcodeScanner.h>
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@interface ScanCardView ()

@end

@implementation ScanCardView

@synthesize viewScan, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MTBBarcodeScanner *scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.viewScan];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                [scanner freezeCapture];
                
                if ([[NetworkHelper sharedInstance]  isConnected] == false) {
                    [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                                   withTitle:NSLocalizedString(@"ERROR", nil)
                                                                  andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                               andMainButton:NSLocalizedString(@"OK", nil)
                                                           CompletionHandler:^(UIAlertAction *action) {
                                                               [scanner unfreezeCapture];
                                                           }
                                                              andOtherButton:nil
                                                           CompletionHandler:nil];
                    
                    return;
                }
//                [scanner stopScanning]; // Hide the scan view
                
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                [delegate didScanCard:code.stringValue];
                [[self navigationController] popViewControllerAnimated:TRUE];
            } error:&error];
            
        } else {
            // The user denied access to the camera
        }
    }];
}

@end

