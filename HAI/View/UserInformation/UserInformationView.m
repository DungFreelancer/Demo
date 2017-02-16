//
//  UserInformationView.m
//  HAI
//
//  Created by Dung Do on 12/2/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "UserInformationView.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "HUDHelper.h"
#import "Constant.h"

@implementation UserInformationView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    
    [self getUserInformation];
}

- (void)getUserInformation {
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
    
    [[NetworkHelper sharedInstance] requestPost:API_USER_INFORMATION paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            
            if ([response valueForKey:RESPONSE_FULLNAME] == [NSNull null]) {
                self.lbName.text = @"";
            } else {
                self.lbName.text = [NSString stringWithFormat:@"%@", [response valueForKey:RESPONSE_FULLNAME]];
            }
            
            if ([response valueForKey:RESPONSE_TYPE] == [NSNull null]) {
                self.lbType.text = @"";
            } else {
                self.lbType.text = [NSString stringWithFormat:@"%@", [response valueForKey:RESPONSE_TYPE]];
            }
            
            if ([response valueForKey:RESPONSE_ADDRESS] == [NSNull null]) {
                self.lbAddress.text = @"";
            } else {
                self.lbAddress.text = [NSString stringWithFormat:@"%@", [response valueForKey:RESPONSE_ADDRESS]];
            }
            
            if ([response valueForKey:RESPONSE_PHONE] == [NSNull null]) {
                self.lbPhone.text = @"";
            } else {
                self.lbPhone.text = [NSString stringWithFormat:@"%@", [response valueForKey:RESPONSE_PHONE]];
            }
            
            if ([response valueForKey:RESPONSE_BIRTHDAY] == [NSNull null]) {
                self.lbBirthday.text = @"";
            } else {
                self.lbBirthday.text = [NSString stringWithFormat:@"%@", [response valueForKey:RESPONSE_BIRTHDAY]];
            }
            
            if ([response valueForKey:RESPONSE_AREA] == [NSNull null]) {
                self.lbArea.text = @"";
            } else {
                self.lbArea.text = [NSString stringWithFormat:@"%@", [response valueForKey:RESPONSE_AREA]];
            }
            
            if ([response valueForKey:RESPONSE_USER] == [NSNull null]) {
                self.lbUser.text = @"";
            } else {
                self.lbUser.text = [NSString stringWithFormat:@"%@", [response valueForKey:RESPONSE_USER]];
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

@end
