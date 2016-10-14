//
//  CheckInModel.m
//  Demo
//
//  Created by Dung Do on 10/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckInModel.h"

@implementation CheckInModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.store forKey:@"store"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.store = [aDecoder decodeObjectForKey:@"store"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.sender = [aDecoder decodeObjectForKey:@"sender"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    
    return self;
}

@end

