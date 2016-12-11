//
//  SupportCell.h
//  HAI
//
//  Created by Dung Do on 11/27/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupportCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbType;
@property (weak, nonatomic) IBOutlet UILabel *lbComment;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@end
