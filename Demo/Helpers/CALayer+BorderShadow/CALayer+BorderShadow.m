//
//  CALayer+Utility.m
//  Demo
//
//  Created by Dung Do on 10/30/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CALayer+BorderShadow.h"

@implementation CALayer (BorderShadow)

- (void)setBorderWithColor:(CGColorRef)color {
    self.cornerRadius = 5;
    self.borderWidth = 1;
    self.borderColor = color;
}

- (void)setShadowWithRadius:(CGFloat)radius {
    self.masksToBounds = NO;
    self.shadowColor = [[UIColor grayColor] CGColor];
    self.shadowOffset = CGSizeMake(0, 2.0f);
    self.shadowOpacity = 1.0f;
    self.shadowRadius = radius;
}

@end
