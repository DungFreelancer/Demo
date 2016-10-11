//
//  UIView+Utils.m
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "UIView+RoundedCorners.h"

@implementation UIView (RoundedCorners)

- (void)applyRoundedCorners {
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

- (void)applyRoundedCornersLess {
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
}

- (void)applyRoundedCornersFull {
    self.layer.cornerRadius = (self.frame.size.width / 2);
    self.layer.masksToBounds = YES;
}

- (void)applyRoundedCornersFullWithColor:(UIColor *)color {
    self.layer.cornerRadius = (self.frame.size.width / 2);
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 3.0f;
    self.layer.masksToBounds = YES;
}

@end
