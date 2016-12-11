//
//  EventView.h
//  HAI
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface EventView : BaseView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbEvent;

@end
