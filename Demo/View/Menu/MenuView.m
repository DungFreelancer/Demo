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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return function.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:function[indexPath.row]];
    
    return cell;
}

@end
