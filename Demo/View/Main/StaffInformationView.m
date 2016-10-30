//
//  ViewController.m
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "StaffInformationView.h"
#import "UIImageView+Download.h"
#import "Constant.h"
#import "ScanCardView.h"
#import "HUDHelper.h"
#import "UtilityClass.h"

@interface StaffInformationView()<ScanCardViewDelegate>

@end

@implementation StaffInformationView

@synthesize imgAvatar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Border button
    self.btnScan.layer.cornerRadius = 5;
    self.btnScan.layer.borderWidth = 1;
    self.btnScan.layer.borderColor = self.btnScan.tintColor.CGColor;
    self.btnScan.layer.masksToBounds = NO;
    
    self.btnScan.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.btnScan.layer.shadowOffset = CGSizeMake(0, 2.0f);
    self.btnScan.layer.shadowOpacity = 1.0f;
    self.btnScan.layer.shadowRadius = 1.0f;
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

