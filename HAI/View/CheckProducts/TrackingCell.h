//
//  TrackingCell.h
//  HAI
//
//  Created by Dung Do on 11/29/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbImportTime;
@property (weak, nonatomic) IBOutlet UILabel *lbExportTime;

@end
