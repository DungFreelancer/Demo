//
//  EventDetail.m
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "EventDetailView.h"
#import "EventAwardView.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "UIImageView+Download.h"
#import "HUDHelper.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation EventDetailView {
    NSArray<NSDictionary *> *arrAward, *arrProduct;
    NSString *type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    self.tbAward.dataSource = self;
    self.tbAward.delegate = self;
    
    self.imgBanner.image = self.banner;
    
    [self getEvetDetail];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_event_award"]) {
        EventAwardView *viewEA = segue.destinationViewController;
        if ([type isEqualToString:@"award"]) {
            viewEA.arrAward = arrAward;
            viewEA.type = @"award";
        } else {
            viewEA.arrAward = arrProduct;
            viewEA.type = @"product";
        }
    }
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
            
            [self.tbAward reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = 0;
    
    if (arrAward.count > 0) {
        rows++;
    }
    if (arrProduct.count > 0) {
        rows++;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"reward_cell" forIndexPath:indexPath];
    
    if (arrAward.count > 0 && indexPath.row == 0) {
        cell.textLabel.text = @"Phần thưởng:";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrAward.count];
    } else if (arrProduct.count > 0 && indexPath.row == 1) {
        cell.textLabel.text = @"Sản phẩm sử dụng tích điểm:";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)arrProduct.count];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        type = @"award";
    } else {
        type = @"product";
    }
    
    [self performSegueWithIdentifier:@"segue_event_award" sender:nil];
}

@end
