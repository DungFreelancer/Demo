//
//  ViewController.m
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckStaffView.h"
#import "NetworkHelper.h"
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
//    [self didScanCard:@"0276\nNGUYỄN NGỌC HƯƠNG GIANG\nNhân viên kế toán\nCÔNG TY CỔ PHẦN NÔNG DƯỢC HAI-CHI NHÁNH AN GIANG\n79 Ấp Hòa Phú 1, Thị Trấn An Châu, Huyện Châu Thành, Tỉnh An Giang"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_scan_card"]) {
        ScanCardView *scv = [segue destinationViewController];
        scv.delegate = self;
    }
}

// ScanCardDelegate.
- (void)didScanCard:(NSString *)result {
    if ([[NetworkHelper sharedInstance]  isConnected] == false) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSArray<NSString *> *arrResult = [result componentsSeparatedByString:@"\n"];
    
    [self.lbName setText:arrResult[1]];
    [self.lbPosition setText:arrResult[2]];
    [self.lbCompany setText:arrResult[3]];
    [self.lbAddress setText:arrResult[4]];
    
    NSString *url = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",
                     API_CHECK_STAFF,
                     PARAM_CODE,
                     arrResult[0],
                     PARAM_USER,
                     [USER_DEFAULT objectForKey:PREF_USER],
                     PARAM_TOKEN,
                     [USER_DEFAULT objectForKey:PREF_TOKEN]];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:@"LOADING" onView:self.view];
    
    [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            NSString *status = [response valueForKey:RESPONSE_STATUS];
            NSString *urlAvatar = [response valueForKey:RESPONSE_AVATAR];
            NSString *urlSignature = [response valueForKey:RESPONSE_SIGNATURE];
            
            [self.lbstatus setText:status];
            
            [[HUDHelper sharedInstance] showLoadingWithTitle:@"LOADING" onView:self.view];
            
            [self.imgAvatar downloadFromURL:urlAvatar withPlaceholder:nil handleCompletion:^(BOOL success) {
                
                [[HUDHelper sharedInstance] hideLoading];
                if (!success) {
                    [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:NSLocalizedString(@"ERROR", nil) andMessage:NSLocalizedString(@"STAFF_NO_AVATAR", nil) andButton:NSLocalizedString(@"OK", nil)];
                }
            }];
            
            [self.imgSignature downloadFromURL:urlSignature withPlaceholder:nil handleCompletion:^(BOOL success) {
                
                [[HUDHelper sharedInstance] hideLoading];
                if (!success) {
                    [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:NSLocalizedString(@"ERROR", nil) andMessage:NSLocalizedString(@"STAFF_NO_SIGNATURE", nil) andButton:NSLocalizedString(@"OK", nil)];
                }
            }];
        }
    }];
}

@end

