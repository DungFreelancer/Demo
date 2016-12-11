//
//  ScanProductView.h
//  HAI
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@protocol ScanProductViewDelegate <NSObject>

- (void)didScanProducts:(NSMutableArray *)result;

@end

@interface ScanProductView : BaseView <UITableViewDataSource, UITableViewDelegate>

@property (weak,nonatomic) id<ScanProductViewDelegate> delegate;
@property (strong,nonatomic) NSMutableArray *arrCodes;

@property (weak, nonatomic) IBOutlet UIView *viewScan;
@property (weak, nonatomic) IBOutlet UIButton *btnStop;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UITableView *tbCode;

- (IBAction)onClickStop:(id)sender;

@end
