//
//  MenuCell.m
//  HAI
//
//  Created by Dung Do on 12/11/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "MenuCell.h"
#import "UIView+RoundedCorners.h"

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.viewBadgeBG applyRoundedCornersFull];
}

@end
