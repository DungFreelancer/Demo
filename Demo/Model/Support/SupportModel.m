//
//  Support.m
//  Demo
//
//  Created by Dung Do on 11/27/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SupportModel.h"

@implementation SupportModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
    }
    
    return self;
}

@end
