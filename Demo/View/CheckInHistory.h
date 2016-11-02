//
//  HistoryCheckIn.h
//  Demo
//
//  Created by Dung Do on 11/2/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface CheckInHistory : BaseView <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbHistory;

@end
