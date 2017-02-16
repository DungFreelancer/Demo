//
//  ResultView.m
//  HAI
//
//  Created by Dung Do on 12/20/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "ResultView.h"
#import "ResultCell.h"

@implementation ResultView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    
    self.tbResult.dataSource = self;
    self.tbResult.delegate = self;
    
    self.lbMessage.text = self.strMessage;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"result_cell" forIndexPath:indexPath];
    
    cell.lbName.text = [self.arrResult[indexPath.row] valueForKey:@"name"];
    cell.lbCode.text = [self.arrResult[indexPath.row] valueForKey:@"code"];
    cell.lbStatus.text = [self.arrResult[indexPath.row] valueForKey:@"status"];
    
    return cell;
}

@end
