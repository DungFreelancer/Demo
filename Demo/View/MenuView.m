//
//  MenuView.m
//  Demo
//
//  Created by Dung Do on 10/29/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "MenuView.h"
#import "Constant.h"

@implementation MenuView {
    NSArray<NSString *> *function;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [[self view] tintColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [[self view] tintColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Setup table view.
    self.tblMenu.dataSource = self;
    self.tblMenu.delegate = self;
    
    // Get function list.
    function = [USER_DEFAULT objectForKey:PREF_FUNCTION];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return function.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:function[indexPath.row]];
    
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
    cell.layer.shadowOpacity = 1.0f;
    cell.layer.shadowRadius = 2.0f;
    
    return cell;
}

@end
