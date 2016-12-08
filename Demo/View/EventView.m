//
//  EventView.m
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "EventView.h"
#import "EventCell.h"
#import "EventDetailView.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "UtilityClass.h"
#import "UIImageView+Download.h"
#import "Constant.h"

@implementation EventView {
    NSMutableArray <NSDictionary *> *arrEvent;
    NSString *eventID;
    UIImage *banner;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    self.navigationController.navigationBarHidden = NO;
    
    self.tbEvent.dataSource = self;
    self.tbEvent.delegate = self;
    self.tbEvent.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    
    arrEvent = [[NSMutableArray alloc] init];
    
    [self getAllEvent];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue_event_detail"]) {
        EventDetailView *viewED = segue.destinationViewController;
        viewED.eventID = eventID;
        viewED.banner = banner;
    }
}

- (void)getAllEvent {
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
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_EVENT paramaters:params completion:^(id response, NSError *error) {
    
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            arrEvent = [response valueForKey:RESPONSE_EVENTS];
            [self.tbEvent reloadData];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE]
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrEvent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"event_cell" forIndexPath:indexPath];
    
    [cell.imgBanner downloadFromURL:[arrEvent[indexPath.row] valueForKey:RESPONSE_EVENTS_IMAGE] withPlaceholder:nil handleCompletion:^(BOOL success) {}];
    cell.lbTitle.text = [arrEvent[indexPath.row] valueForKey:RESPONSE_EVENTS_NAME];
    cell.lbDate.text = [arrEvent[indexPath.row] valueForKey:RESPONSE_EVENTS_TIME];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    eventID = [arrEvent[indexPath.row] valueForKey:RESPONSE_EVENTS_ID];
    banner = ((EventCell *) [tableView cellForRowAtIndexPath:indexPath]).imgBanner.image;
    
    [self performSegueWithIdentifier:@"segue_event_detail" sender:nil];
}

@end
