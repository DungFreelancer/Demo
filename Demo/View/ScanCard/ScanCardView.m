//
//  ScanCardView.m
//  Demo
//
//  Created by Dung Do on 10/11/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "ScanCardView.h"
#import "CheckStaffView.h"
#import "CALayer+BorderShadow.h"
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
    
    if ([[self.navigationController parentViewController] isKindOfClass:[CheckStaffView class]]) {
        self.lbTotal.hidden = YES;
    } else {
        self.lbTotal.hidden = NO;
        [self.lbTotal.layer setBorderWithColor:[UIColor redColor].CGColor];
        
        self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.arrCodes.count];
    }
    
    MTBBarcodeScanner *scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.viewScan];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [scanner startScanningWithResultBlock:^(NSArray *codes) {
                [scanner freezeCapture];
                
                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
                DLOG(@"Code=%@", code.stringValue);
            
                if ([[self.navigationController parentViewController] isKindOfClass:[CheckStaffView class]]) {
                    [delegate didScanCard:code.stringValue];
                    [[self navigationController] popViewControllerAnimated:YES];
                } else {
                    if ([code.stringValue isEqualToString:self.arrCodes.lastObject] == NO) {
                        [self.arrCodes addObject:code.stringValue];
                        self.lbTotal.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.arrCodes.count];
                    }
                    [scanner unfreezeCapture];
                }
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

