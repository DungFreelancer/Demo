//
//  Base.m
//  HAI
//
//  Created by Dung Do on 9/27/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"
#import "Constant.h"

@implementation BaseView

- (void)setNavBarTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    self.navigationItem.titleView = label;
}

- (void)setBackBarItem {
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, 0, 30, 30);
    [btnLeft addTarget:self action:@selector(onClickBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeft setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11")) {
        [btnLeft.widthAnchor constraintEqualToConstant:30].active = YES;
        [btnLeft.heightAnchor constraintEqualToConstant:30].active = YES;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    self.navigationItem.hidesBackButton = YES;
}

- (void)onClickBackBarItem:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollToBottomOnTableView:(UITableView *)tableView {
    NSInteger lastSection = tableView.numberOfSections - 1;
    NSInteger lastRow = [tableView numberOfRowsInSection:lastSection] - 1;
    if (lastRow < 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:lastSection];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
