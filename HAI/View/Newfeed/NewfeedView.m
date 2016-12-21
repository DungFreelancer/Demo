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
    NewfeedViewModel *vmNewfeed;
    NSInteger indexNewfeed;
    NSMutableArray<NSDictionary *> *arrNewfeed;
    int pageno;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    self.navigationController.navigationBarHidden = NO;
    
    self.tbNewfeed.dataSource = self;
    self.tbNewfeed.delegate = self;
    self.tbNewfeed.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    
    vmNewfeed = [[NewfeedViewModel alloc] init];
    pageno = 0;
    arrNewfeed = [[NSMutableArray alloc] init];
    [self getAllNewfeeds];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_newfeed_detail"]) {
        NewfeedDetailView *viewND = (NewfeedDetailView *) [segue destinationViewController];
        viewND.titleNF = [arrNewfeed[indexNewfeed] valueForKey:@"title"];
        viewND.contentNF = [arrNewfeed[indexNewfeed] valueForKey:@"content"];
        viewND.timeNF = [arrNewfeed[indexNewfeed] valueForKey:@"time"];
    }
}

- (void)getAllNewfeeds {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    [params setObject:[NSNumber numberWithInt:pageno] forKey:PARAM_PAGENO];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_GET_NOTIFICATION paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            
            if (((NSArray *) [response valueForKey:RESPONSE_NOTIFICATION]).count > 0) {
                [arrNewfeed addObjectsFromArray:[response valueForKey:RESPONSE_NOTIFICATION]];
                [self.tbNewfeed reloadData];
                [self saveNewfeedsFromArray];
                pageno++;
            }
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE]
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (void)saveNewfeedsFromArray {
    [vmNewfeed loadNewfeeds];
    
    for (int i = 0; i < arrNewfeed.count; ++i) {
        
        // Search from database.
        BOOL isExist = NO;
        for (int j = 0; j < vmNewfeed.arrNewfeed.count; ++j) {
            if ([[arrNewfeed[i] valueForKey:@"id"] isEqualToString:vmNewfeed.arrNewfeed[j].newfeedID]) {
                isExist = YES;
                break;
            }
        }
        
        // Add to database if don't exist.
        if (!isExist) {
            NewfeedModel *newfeed = [[NewfeedModel alloc] init];
            newfeed.newfeedID  = [arrNewfeed[i] valueForKey:@"id"];
            newfeed.isReaded  = NO;
            
            [vmNewfeed.arrNewfeed addObject:newfeed];
        }
    }
    
    [vmNewfeed saveNewfeeds];
}

// MARK: - UITableviewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrNewfeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewfeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newfeed_cell" forIndexPath:indexPath];
    
    cell.lbTitle.text = [arrNewfeed[indexPath.row] valueForKey:@"title"];
    cell.lbContent.text = [arrNewfeed[indexPath.row] valueForKey:@"content"];
    cell.lbTime.text = [arrNewfeed[indexPath.row] valueForKey:@"time"];
    
    // Make regular font when this newfeed was not readed.
    for (int i = 0; i < vmNewfeed.arrNewfeed.count; ++i) {
        if ([[arrNewfeed[indexPath.row] valueForKey:@"id"] isEqualToString:vmNewfeed.arrNewfeed[i].newfeedID] &&
            vmNewfeed.arrNewfeed[i].isReaded) {
            cell.lbTitle.font = [UIFont systemFontOfSize:17];
            break;
        }
    }
    
    if (indexPath.row == (arrNewfeed.count - 1)) { // Reach to last item will load more newfeed.
        [self getAllNewfeeds];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Make this newfeed was readed.
    vmNewfeed.arrNewfeed[indexPath.row].isReaded = YES;
    [vmNewfeed saveNewfeeds];
    [self.tbNewfeed reloadData];
    
    indexNewfeed = indexPath.row;
    [self performSegueWithIdentifier:@"segue_newfeed_detail" sender:nil];
}

@end
