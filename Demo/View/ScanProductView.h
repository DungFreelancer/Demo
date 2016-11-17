//
//  ScanProductView.h
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@protocol ScanProductViewDelegate <NSObject>

- (void)didScanProducts:(NSMutableArray *)result;

@end

@interface ScanProductView : BaseView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak,nonatomic) id<ScanProductViewDelegate> delegate;
@property (strong,nonatomic) NSMutableArray *arrCodes;

@property (weak, nonatomic) IBOutlet UIView *viewScan;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UITableView *tbCode;

- (IBAction)onClickSave:(id)sender;

@end
