//
//  CheckProductsView.h
//  HAI
//
//  Created by Dung Do on 11/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"
#import "ScanCardView.h"

@interface CheckProductsView : BaseView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, ScanCardViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UITableView *tbTracking;

- (IBAction)onClickCheck:(id)sender;

@end
