//
//  EventDetail.m
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "EventDetailView.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "UIImageView+Download.h"
#import "HUDHelper.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation EventDetailView {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    // Setup button
    [self.btnMessage.layer setShadowWithRadius:1.0f];
    [self.btnMessage.layer setBorderWithColor: self.btnMessage.tintColor.CGColor];
    
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

- (IBAction)onClickMessage:(id)sender {
}

// MARK: - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
