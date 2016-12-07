//
//  EventAwardView.m
//  Demo
//
//  Created by Dung Do on 12/7/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "EventAwardView.h"
#import "EventDetailCell.h"
#import "UIImageView+Download.h"

@implementation EventAwardView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    
    if ([self.type isEqualToString:@"award"]) {
        self.title = @"Phần thưởng";
    } else {
        self.title = @"Sản phẩm";
    }
    
    self.tbAward.dataSource = self;
    self.tbAward.delegate = self;
}

// MARK: - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrAward.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailCell *cell;
    
    if ([self.type isEqualToString:@"award"]) {
        cell = (EventDetailCell *) [tableView dequeueReusableCellWithIdentifier:@"award_cell" forIndexPath:indexPath];
        [cell.imgAward downloadFromURL:[self.arrAward[indexPath.row] valueForKey:@"image"]
                       withPlaceholder:nil handleCompletion:^(BOOL success) {}];
        cell.lbName.text = [self.arrAward[indexPath.row] valueForKey:@"name"];
        cell.lbPoint.text = [self.arrAward[indexPath.row] valueForKey:@"point"];
    } else {
        cell = (EventDetailCell *) [tableView dequeueReusableCellWithIdentifier:@"product_cell" forIndexPath:indexPath];
        cell.lbName.text = [self.arrAward[indexPath.row] valueForKey:@"name"];
        cell.lbPoint.text = [self.arrAward[indexPath.row] valueForKey:@"point"];
    }
    
    return cell;
}

@end
