//
//  ViewController.m
//  Demo
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "StaffInformationView.h"
#import <Reachability/Reachability.h>
#import "UIImageView+Download.h"
#import "Constant.h"
#import "ScanCardView.h"
#import "HUDHelper.h"

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
    self.btnScan.layer.masksToBounds = true;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_scan_card"]) {
        ScanCardView *scv = [segue destinationViewController];
        scv.delegate = self;
    }
}

// ScanCardDelegate.
- (void)didScanCard:(NSString *)result {
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    NSArray<NSString *> *arrResult = [result componentsSeparatedByString:@"\n"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", API_STAFF_INFORMATION, arrResult[0]];
    [self.imgAvatar downloadFromURL:url withPlaceholder:nil];
    [self.lbName setText:arrResult[1]];
    [self.lbPosition setText:arrResult[2]];
    [self.lbCompany setText:arrResult[3]];
    [self.lbAddress setText:arrResult[4]];
    
    [[HUDHelper sharedInstance] hideLoading];
}

@end

