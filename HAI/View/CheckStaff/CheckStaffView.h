//
//  ViewController.h
//  HAI
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface CheckStaffView : BaseView

@property (weak, nonatomic) IBOutlet UIScrollView *scrStaff;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbCode;
@property (weak, nonatomic) IBOutlet UILabel *lbstatus;
@property (weak, nonatomic) IBOutlet UILabel *lbPosition;
@property (weak, nonatomic) IBOutlet UILabel *lbCompany;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgSignature;

@property (weak, nonatomic) IBOutlet UIButton *btnScan;

@end

