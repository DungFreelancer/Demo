//
//  EventCell.h
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;


@end
