//
//  CheckInHistoryCell.h
//  Demo
//
//  Created by Dung Do on 11/3/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckInHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;
@property (weak, nonatomic) IBOutlet UILabel *txtDate;
@property (weak, nonatomic) IBOutlet UILabel *txtComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgSended;

@end
