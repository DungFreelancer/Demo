//
//  ResultView.h
//  HAI
//
//  Created by Dung Do on 12/20/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface ResultView : BaseView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSArray<NSDictionary *> *arrResult;
@property (weak, nonatomic) IBOutlet UITableView *tbResult;

@end
