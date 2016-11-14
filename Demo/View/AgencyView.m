//
//  AgencyView.m
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "AgencyView.h"

@implementation AgencyView {
    NSArray<NSString *> *arrAgency;
    NSArray<NSString *> *arrFilteredAgency;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    // Setup table agency.
    self.tbAgency.dataSource = self;
    self.tbAgency.delegate = self;
    
    // Setup search controller agency.
    txtSearch = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    txtSearch.searchResultsUpdater = self;
    txtSearch.dimsBackgroundDuringPresentation = NO;
    txtSearch.searchBar.placeholder = @"Đại lý";
    txtSearch.searchBar.barTintColor = [[self view] tintColor];
    self.definesPresentationContext = YES;
    self.tbAgency.tableHeaderView = txtSearch.searchBar;
    
    // Data to test.
    arrAgency = @[@"Tôi", @"tên", @"là"];
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([txtSearch.searchBar.text isEqualToString:@""]) {
        return arrAgency.count;
    }
    
    return arrFilteredAgency.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"agency_cell" forIndexPath:indexPath];
    
    if ([txtSearch.searchBar.text isEqualToString:@""]) {
        cell.textLabel.text = arrAgency[indexPath.row];
    } else {
        cell.textLabel.text = arrFilteredAgency[indexPath.row];
    }
    
    return cell;
}

// MARK: - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchController.searchBar.text];
    arrFilteredAgency = [arrAgency filteredArrayUsingPredicate:filter];
    
    // Reload the tableview.
    [self.tbAgency reloadData];
}

@end

