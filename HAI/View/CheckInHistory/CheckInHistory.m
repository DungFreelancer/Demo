//
//  HistoryCheckIn.m
//  HAI
//
//  Created by Dung Do on 11/2/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckInHistory.h"
#import "CheckInHistoryCell.h"
#import "UtilityClass.h"
#import "CheckInViewModel.h"

@implementation CheckInHistory {
    CheckInViewModel *vmCheckIn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbHistory.dataSource = self;
    self.tbHistory.delegate = self;
    self.tbHistory.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    
    vmCheckIn = [[CheckInViewModel alloc] init];
    [vmCheckIn loadCheckIns];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [super scrollToBottomOnTableView:self.tbHistory];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return vmCheckIn.arrCheckIn.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckInHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history_cell" forIndexPath:indexPath];
    
    NSDate *date = [[UtilityClass sharedInstance] stringToDate:vmCheckIn.arrCheckIn[indexPath.row].date withFormate:@"MM/dd/yyyy HH:mm"];
    cell.txtDate.text = [[UtilityClass sharedInstance] DateToString:date withFormate:@"dd/MM/yyyy - HH:mm"];
    cell.imgPicture.image = [UIImage imageWithData:vmCheckIn.arrCheckIn[indexPath.row].image];
    cell.txtComment.text = vmCheckIn.arrCheckIn[indexPath.row].comment;
    cell.txtAgencyCode.text = vmCheckIn.arrCheckIn[indexPath.row].agencyCode;
    
    if (vmCheckIn.arrCheckIn[indexPath.row].isSended) {
        cell.txtStatus.text = @"Đã cập nhật.";
    } else {
        cell.txtStatus.text = @"Chưa cập nhật hoàn thành!";
    }
    
    return cell;
}


@end
