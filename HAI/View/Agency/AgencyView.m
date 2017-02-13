//
//  AgencyView.m
//  HAI
//
//  Created by Dung Do on 12/20/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "AgencyView.h"
#import "NetworkHelper.h"
#import "HUDHelper.h"
#import "Constant.h"
#import "UtilityClass.h"

@implementation AgencyView {
    NSMutableArray<NSDictionary *> *arrAgency;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    
    self.tbAgency.dataSource = self;
    self.tbAgency.delegate = self;
    self.tbAgency.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    self.txtAgency.delegate = self;
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [singleTapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (IBAction)onClickAgency:(id)sender {
    if (![self.txtAgency.text isEqualToString:@""]) {
        [self searchAgencyWithName:self.txtAgency.text];
    }
}

- (void)searchAgencyWithName:(NSString *)name {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSString *type;
    if ([self.segStatus selectedSegmentIndex] == 0) {
        type = @"1";
    } else {
        type = @"2";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    [params setObject:name forKey:PARAM_SEARCH];
    [params setObject:type forKey:PARAM_TYPE];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_FIND_AGENCY paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            
            arrAgency = [response valueForKey:RESPONSE_AGENCES];
            [self.tbAgency reloadData];
            
            [self.txtAgency resignFirstResponder];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE]
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtAgency &&
        ![textField.text isEqualToString:@""]) {
        [self searchAgencyWithName:textField.text];
    }
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrAgency.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"agency_cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [arrAgency[indexPath.row] valueForKey:@"code"];
    cell.detailTextLabel.text = [arrAgency[indexPath.row] valueForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didChooseAgency:[arrAgency[indexPath.row] valueForKey:@"code"]];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

// MARK: - UIGestureRecognizerDelegate
- (void)handleSingleTapGesture {
    [self.txtAgency resignFirstResponder];
}

@end
