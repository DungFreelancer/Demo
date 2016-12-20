//
//  NewfeedModel.m
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "NewfeedModel.h"

@implementation NewfeedModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.newfeedID forKey:@"newfeedID"];
    [aCoder encodeBool:self.isReaded forKey:@"isReaded"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.newfeedID = [aDecoder decodeObjectForKey:@"newfeedID"];
        self.isReaded = [aDecoder decodeBoolForKey:@"isReaded"];
    }
    
    return self;
}

@end
