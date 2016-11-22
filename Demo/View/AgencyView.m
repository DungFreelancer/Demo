//
//  AgencyView.m
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "AgencyView.h"
#import "HUDHelper.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

@implementation AgencyView {
    NSArray<NSDictionary *> *arrAgency;
    NSArray<NSDictionary *> *arrFilteredAgency;
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
    txtSearch.searchBar.placeholder = @"Tìm Đại lý";
    txtSearch.searchBar.barTintColor = [[self view] tintColor];
    self.definesPresentationContext = YES;
    self.tbAgency.tableHeaderView = txtSearch.searchBar;
    
    [self getAllAgency];
}

- (void)getAllAgency {
    if ([[NetworkHelper sharedInstance]  isConnected] == false) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", API_GET_AGENCYS, PARAM_USER, [USER_DEFAULT objectForKey:PREF_USER], PARAM_TOKEN, [USER_DEFAULT objectForKey:PREF_TOKEN]];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestGet:url paramaters:nil completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            arrAgency = [response valueForKey:RESPONSE_AGENCY];
            [self.tbAgency reloadData];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:NSLocalizedString(@"AGENCY_ERROR", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
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
        cell.textLabel.text = [arrAgency[indexPath.row] valueForKey:@"store"];
        cell.detailTextLabel.text = [arrAgency[indexPath.row] valueForKey:@"deputy"];
    } else {
        cell.textLabel.text = [arrFilteredAgency[indexPath.row] valueForKey:@"store"];
        cell.detailTextLabel.text = [arrFilteredAgency[indexPath.row] valueForKey:@"deputy"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([txtSearch.searchBar.text isEqualToString:@""]) {
        [self.delegate didGetAgency:arrAgency[indexPath.row]];
    } else {
        [self.delegate didGetAgency:arrFilteredAgency[indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"store CONTAINS[cd] %@ || deputy CONTAINS[cd] %@", searchController.searchBar.text, searchController.searchBar.text];
    arrFilteredAgency = [arrAgency filteredArrayUsingPredicate:filter];
    
    // Reload the tableview.
    [self.tbAgency reloadData];
}

@end

