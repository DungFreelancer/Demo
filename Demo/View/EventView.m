//
//  EventView.m
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "EventView.h"
#import "EventCell.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation EventView {
    NSMutableArray <NSDictionary *> *arrEvent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbEvent.dataSource = self;
    self.tbEvent.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrEvent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"event_cell" forIndexPath:indexPath];
    
    cell.imgBanner = [arrEvent valueForKey:@""];
    cell.lbTitle = [arrEvent valueForKey:@""];
    cell.lbDate = [arrEvent valueForKey:@""];
    
    return cell;
}

@end
