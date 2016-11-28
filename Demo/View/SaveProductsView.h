//
//  SaveProducts.h
//  Demo
//
//  Created by Dung Do on 11/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"
#import "ScanCardView.h"

@interface SaveProductsView : BaseView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, ScanCardViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UITableView *tbCodes;

- (IBAction)onClickSend:(id)sender;


@end
