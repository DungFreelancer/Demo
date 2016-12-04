//
//  SaveProducts.h
//  Demo
//
//  Created by Dung Do on 11/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface SaveProductsView : BaseView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITableView *tbCodes;

- (IBAction)onClickAdd:(id)sender;
- (IBAction)onClickSend:(id)sender;

@end
