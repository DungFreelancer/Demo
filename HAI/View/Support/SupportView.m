//
//  SupportView.m
//  HAI
//
//  Created by Dung Do on 11/13/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SupportView.h"
#import "SupportViewModel.h"
#import "SupportCell.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "CALayer+BorderShadow.h"
#import "HUDHelper.h"
#import "Constant.h"

@implementation SupportView {
    SupportViewModel *vmSupport;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    // Setup button & text view.
    [self.btnSendRequest.layer setShadowWithRadius:1.0f];
    [self.btnSendRequest.layer setBorderWithColor:self.btnSendRequest.tintColor.CGColor];
    
    [self.txtComment.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    [self.txtComment setTextColor:[UIColor lightGrayColor]];
    self.txtComment.delegate = self;
    [self.txtComment becomeFirstResponder];
    
    self.tbSupport.dataSource = self;
    self.tbSupport.delegate = self;
    self.tbSupport.tableFooterView = [[UIView alloc] init]; // Remove separator at bottom.
    
    vmSupport = [[SupportViewModel alloc] init];
    [vmSupport loadSupports];
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (IBAction)onClickSendRequest:(id)sender {
    if ([[NetworkHelper sharedInstance]  isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSString *comment = [self.txtComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([comment isEqualToString:@"Nội dung"] ||
        [comment isEqualToString:@""]) {
        ELOG(@"%@", NSLocalizedString(@"NO_COMMENT", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_COMMENT", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSString *type;
    if ([self.segType selectedSegmentIndex] == 0) {
        type = @"sp";
    } else {
        type = @"sc";
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    [params setObject:self.txtComment.text forKey:PARAM_CONTENT];
    [params setObject:type forKey:PARAM_TYPE];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    
    [[NetworkHelper sharedInstance] requestPost:API_SUPPORT paramaters:params completion:^(id response, NSError *error) {
        
        [[HUDHelper sharedInstance] hideLoading];
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:nil
                                                          andMessage:NSLocalizedString(@"SUPPORT_SENDED", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
            [self saveLogSupport];
            [self cleanAllView];
            [self.tbSupport reloadData];
            [super scrollToBottomOnTableView:self.tbSupport];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"SUPPORT_ERROR", nil)
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];    
}

- (void)saveLogSupport {
    NSString *type;
    if ([self.segType selectedSegmentIndex] == 0) {
        type = @"Hổ trợ";
    } else {
        type = @"Sự cố";
    }
    
    SupportModel *support = [[SupportModel alloc] init];
    support.type = type;
    support.comment = self.txtComment.text;
    support.date = [[UtilityClass sharedInstance] DateToString:[NSDate date] withFormate:@"dd/MM/yyyy HH:mm"];
    
    [vmSupport.arrSupport addObject:support];
    [vmSupport saveSupports];
}

- (void)cleanAllView {
    [self.segType setSelectedSegmentIndex:0];
    
    self.txtComment.text = @"Nội dung";
    [self.txtComment setTextColor:[UIColor lightGrayColor]];
    [self handleSingleTapGesture];
}

// MARK: - UITableViewDataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return vmSupport.arrSupport.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SupportCell *cell = (SupportCell *) [tableView dequeueReusableCellWithIdentifier:@"support_cell" forIndexPath:indexPath];
    
    cell.lbType.text = vmSupport.arrSupport[indexPath.row].type;
    cell.lbComment.text = vmSupport.arrSupport[indexPath.row].comment;
    cell.lbDate.text = vmSupport.arrSupport[indexPath.row].date;
    
    return cell;
}

// MARK: - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Nội dung"]) {
        textView.text = @"";
        [textView setTextColor:[UIColor darkTextColor]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Nội dung";
        [textView setTextColor:[UIColor lightGrayColor]];
    }
}

// MARK: - UIGestureRecognizerDelegate
-(void)handleSingleTapGesture {
    [self.txtComment resignFirstResponder];
}

@end
