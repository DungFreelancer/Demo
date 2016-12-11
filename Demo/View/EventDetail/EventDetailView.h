//
//  EventDetai.h
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface EventDetailView : BaseView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSString *eventID;
@property (weak, nonatomic) UIImage *banner;

@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UITableView *tbAward;

@end
