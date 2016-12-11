//
//  MenuView.m
//  Demo
//
//  Created by Dung Do on 10/29/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "MenuView.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "CALayer+BorderShadow.h"
#import "UtilityClass.h"
#import "CheckInViewModel.h"
#import "Constant.h"

@implementation MenuView {
    NSArray<NSString *> *function;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup table view.
    self.tblMenu.dataSource = self;
    self.tblMenu.delegate = self;
    
    [self setBanner];
    
    // Get function list.
//    function = [USER_DEFAULT objectForKey:PREF_FUNCTION];
    function = [[NSArray alloc] initWithObjects:@"checkin", @"checkstaff", @"products", @"event", @"setting", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Setup navigation bar.
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.barTintColor = [[self view] tintColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [[self view] tintColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)setBanner {
    // Banner's image.
    NSString *name = [NSString stringWithFormat:@"banner_%d", arc4random_uniform(7) + 1];
    UIView *imgBanner = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 self.view.frame.size.width,
                                                                 self.view.frame.size.height / 4)];
    [imgBanner setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:name]]];
    
    // Banner's title.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, imgBanner.frame.size.height - 70 - 8, 70, 70)];
    title.text = @"HAI";
    title.font = [UIFont systemFontOfSize:50];
    title.numberOfLines = 1;
    title.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    title.adjustsFontSizeToFitWidth = YES;
    title.minimumScaleFactor = 10.0f/12.0f;
    title.clipsToBounds = YES;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentLeft;
    [imgBanner addSubview:title];
    
    [self.tblMenu setTableHeaderView:imgBanner];
}

// MARK: - Change Status's color
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// MARK: - UItableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return function.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:function[indexPath.row]];
    
    return cell;
}

@end
