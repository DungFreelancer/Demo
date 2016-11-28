//
//  IEProductsView.h
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"
#import "ScanProductView.h"

@interface ProductsView : BaseView <ScanProductViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segStatus;
@property (strong, nonatomic) IBOutlet UIView *lbNameAgency;
@property (weak, nonatomic) IBOutlet UILabel *lbAgency;
@property (weak, nonatomic) IBOutlet UIButton *btnAgency;
@property (weak, nonatomic) IBOutlet UIButton *btnScanProduct;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UITableView *tbCode;

- (IBAction)onClickUpdate:(id)sender;
- (IBAction)onClickSave:(id)sender;

@end
