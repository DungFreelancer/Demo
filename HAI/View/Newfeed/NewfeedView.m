//
//  NewfeedView.m
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "NewfeedView.h"
#import "NewfeedCell.h"
#import "NewfeedDetailView.h"
#import "NewfeedViewModel.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation NewfeedView {
    NewfeedViewModel *vmNewFeed;
    NSInteger indexNewfeed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    self.navigationController.navigationBarHidden = NO;
    
    self.tbNewfeed.dataSource = self;
    self.tbNewfeed.delegate = self;
    self.tbNewfeed.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    
    vmNewFeed = [[NewfeedViewModel alloc] init];
    [vmNewFeed loadNewfeeds];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_newfeed_detail"]) {
        NewfeedDetailView *viewND = (NewfeedDetailView *) [segue destinationViewController];
        viewND.lbTitle.text = [vmNewFeed.arrNewfeed[indexNewfeed] valueForKey:@"title"];
        viewND.lbMessage.text = [vmNewFeed.arrNewfeed[indexNewfeed] valueForKey:@"message"];
    }
}

// MARK: - UITableviewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return vmNewFeed.arrNewfeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewfeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newfeed_cell" forIndexPath:indexPath];
    
    cell.lbTitle.text = [vmNewFeed.arrNewfeed[indexPath.row] valueForKey:@"title"];
    cell.lbMessage.text = [vmNewFeed.arrNewfeed[indexPath.row] valueForKey:@"message"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    indexNewfeed = indexPath.row;
    [self performSegueWithIdentifier:@"segue_newfeed_detail" sender:nil];
}

@end
