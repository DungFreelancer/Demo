//
//  IEProductsView.h
//  HAI
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"
#import "ScanProductView.h"

@interface ProductsView : BaseView <ScanProductViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnScanProduct;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lbReceiver;
@property (weak, nonatomic) IBOutlet UITextField *txtReceiver;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UITableView *tbCode;

- (IBAction)onClickUpdate:(id)sender;
- (IBAction)onClickStatus:(id)sender;
- (IBAction)onClickAdd:(id)sender;
- (IBAction)onClickMore:(id)sender;

@end
