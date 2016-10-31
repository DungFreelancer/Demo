//
//  ViewController.m
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckStaffView.h"
#import "UIImageView+Download.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"
#import "ScanCardView.h"
#import "HUDHelper.h"
#import "UtilityClass.h"

@interface CheckStaffView()<ScanCardViewDelegate>

@end

@implementation CheckStaffView

@synthesize imgAvatar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setBackBarItem];
    
    // Setup button.
    [self.btnScan.layer setShadowWithRadius:1.0f];
    [self.btnScan.layer setBorderWithColor:self.btnScan.tintColor.CGColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_scan_card"]) {
        ScanCardView *scv = [segue destinationViewController];
        scv.delegate = self;
    }
}

// ScanCardDelegate.
- (void)didScanCard:(NSString *)result {
//    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    NSArray<NSString *> *arrResult = [result componentsSeparatedByString:@"\n"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_STAFF_INFORMATION, arrResult[0]];
    [self.imgAvatar downloadFromURL:url withPlaceholder:nil handleCompletion:^(BOOL success) {
        
//        [[HUDHelper sharedInstance] hideLoading];
        if (!success) {
            [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:NSLocalizedString(@"ERROR", nil) andMessage:NSLocalizedString(@"STAFF_NO_IMAGE", nil) andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
    [self.lbName setText:arrResult[1]];
    [self.lbPosition setText:arrResult[2]];
    [self.lbCompany setText:arrResult[3]];
    [self.lbAddress setText:arrResult[4]];
}

@end

