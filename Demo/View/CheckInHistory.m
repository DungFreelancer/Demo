//
//  HistoryCheckIn.m
//  Demo
//
//  Created by Dung Do on 11/2/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckInHistory.h"
#import "CheckInHistoryCell.h"
#import "UtilityClass.h"
#import "CheckInViewModel.h"

@implementation CheckInHistory {
    CheckInViewModel *ciViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbHistory.dataSource = self;
    self.tbHistory.delegate = self;
    
    ciViewModel = [[CheckInViewModel alloc] init];
    [ciViewModel loadCheckIns];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ciViewModel.arrCheckIn.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckInHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"history_cell" forIndexPath:indexPath];
    
    NSDate *date = [[UtilityClass sharedInstance] stringToDate:ciViewModel.arrCheckIn[indexPath.row].date withFormate:@"MM/dd/yyyy HH:mm"];
    cell.txtDate.text = [[UtilityClass sharedInstance] DateToString:date withFormate:@"dd/MM/yyyy - HH:mm"];
    cell.imgPicture.image = [UIImage imageWithData:ciViewModel.arrCheckIn[indexPath.row].image];
    cell.txtComment.text = ciViewModel.arrCheckIn[indexPath.row].comment;
    
    if (ciViewModel.arrCheckIn[indexPath.row].isSended) {
        cell.imgSended.image = [UIImage imageNamed:@"sended"];
    } else {
        cell.imgSended.image = nil;
    }
    
    return cell;
}


@end
