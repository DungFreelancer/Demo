//
//  MenuView.m
//  Demo
//
//  Created by Dung Do on 10/29/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "MenuView.h"
#import "CALayer+BorderShadow.h"
#import "UtilityClass.h"
#import "CheckInViewModel.h"
#import "Constant.h"

@implementation MenuView {
    NSArray<NSString *> *function;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup navigation bar.
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [[self view] tintColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [[self view] tintColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Setup table view.
    self.tblMenu.dataSource = self;
    self.tblMenu.delegate = self;
    
    // Get function list.
    function = [USER_DEFAULT objectForKey:PREF_FUNCTION];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return function.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:function[indexPath.row]];
    
    [cell.layer setShadowWithRadius:2.0f];
    
    return cell;
}

- (IBAction)onClickLogout:(id)sender {
    CheckInViewModel *ciViewModel = [[CheckInViewModel alloc] init];
    
    if ([ciViewModel numberOfUnsended] > 0) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:nil
                                                      andMessage:NSLocalizedString(@"CHECKIN_WARRNING", nil)
                                                   andMainButton:NSLocalizedString(@"CHECKIN_CANCEL", nil)
                                               CompletionHandler:nil
                                                  andOtherButton:NSLocalizedString(@"CHECKIN_DELETE", nil)
                                               CompletionHandler:^(UIAlertAction *action) {
                                                   [ciViewModel clearCheckIns];
                                                   
                                                   self.navigationController.navigationBarHidden = YES;
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }];
        
    } else {
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
