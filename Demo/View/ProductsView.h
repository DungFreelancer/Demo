//
//  ProductsView.h
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"
#import "AgencyView.h"
#import "ScanProductView.h"

@interface ProductsView : BaseView <AgencyViewDelegate,ScanProductViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbAgency;
@property (weak, nonatomic) IBOutlet UIButton *btnScanProduct;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UITableView *tbCode;

- (IBAction)onClickUpdate:(id)sender;

@end
