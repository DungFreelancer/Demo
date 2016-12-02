//
//  EventDetail.m
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "EventDetailView.h"
#import "EventDetailCell.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "UIImageView+Download.h"
#import "HUDHelper.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation EventDetailView {
    NSArray<NSDictionary *> *arrAward, *arrProduct;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbReward.dataSource = self;
    self.tbReward.delegate = self;
    
    self.imgBanner.image = self.banner;
    
    [self getEvetDetail];
}

- (void)getEvetDetail {
    if ([[NetworkHelper sharedInstance] isConnected] == NO) {
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
    [params setObject:self.eventID forKey:PARAM_EVENT_ID];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_EVENT_DETAIL paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            
            self.lbTitle.text = [response valueForKey:RESPONSE_EVENTS_NAME];
            self.lbContent.text = [response valueForKey:RESPONSE_EVENTS_DESCRIBE];
            self.lbDate.text = [response valueForKey:RESPONSE_EVENTS_TIME];
            
            arrAward = [response valueForKey:RESPONSE_EVENTS_AWARDS];
            arrProduct = [response valueForKey:RESPONSE_EVENTS_PRODUCTS];
            
            [self.tbReward reloadData];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE]
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

// MARK: - UITableViewDataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return arrAward.count;
    } else {
        return arrProduct.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (arrAward.count == 0) {
            return nil;
        } else {
            return @"Phần thưởng:";
        }
    } else {
        if (arrProduct.count == 0) {
            return nil;
        } else {
            return @"Sản phẩm sử dụng tích điểm:";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailCell *cell;
    
    if (indexPath.section == 0) {
        cell = (EventDetailCell *) [tableView dequeueReusableCellWithIdentifier:@"reward_cell" forIndexPath:indexPath];
        [cell.imgAward downloadFromURL:[arrAward[indexPath.row] valueForKey:@"image"]
                       withPlaceholder:nil handleCompletion:^(BOOL success) {}];
        cell.lbName.text = [arrAward[indexPath.row] valueForKey:@"name"];
        cell.lbPoint.text = [arrAward[indexPath.row] valueForKey:@"point"];
    } else {
        cell = (EventDetailCell *) [tableView dequeueReusableCellWithIdentifier:@"product_cell" forIndexPath:indexPath];
        cell.lbName.text = [arrProduct[indexPath.row] valueForKey:@"name"];
        cell.lbPoint.text = [arrProduct[indexPath.row] valueForKey:@"point"];
    }
    
    return cell;
}

@end
