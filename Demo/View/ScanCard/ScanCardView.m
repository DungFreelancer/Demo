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
    
    [self setBackBarItem];
    
    MTBBarcodeScanner *scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.viewScan];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                [scanner freezeCapture];
//                [scanner stopScanning]; // Hide the scan view
                
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                [delegate didScanCard:code.stringValue];
                [[self navigationController] popViewControllerAnimated:YES];
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

@end

