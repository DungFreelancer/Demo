//
//  UIView+Utils.h
//  TemplateObjC
//
//  Created by Dung Do on 9/18/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundedCorners)

- (void)applyRoundedCorners;
- (void)applyRoundedCornersLess;
- (void)applyRoundedCornersFull;
- (void)applyRoundedCornersFullWithColor:(UIColor *)color;

@end
