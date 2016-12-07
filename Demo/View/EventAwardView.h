//
//  EventAwardView.h
//  Demo
//
//  Created by Dung Do on 12/7/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface EventAwardView : BaseView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSString *type;
@property (weak, nonatomic) NSArray<NSDictionary *> *arrAward;
@property (weak, nonatomic) IBOutlet UITableView *tbAward;

@end
