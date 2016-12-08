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
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.extension forKey:@"extension"];
    [aCoder encodeObject:self.agencyCode forKey:@"agencyCode"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longtitude forKey:@"longtitude"];
    [aCoder encodeBool:self.isSended forKey:@"isSended"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.extension = [aDecoder decodeObjectForKey:@"extension"];
        self.agencyCode = [aDecoder decodeObjectForKey:@"agencyCode"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longtitude = [aDecoder decodeObjectForKey:@"longtitude"];
        self.isSended = [aDecoder decodeBoolForKey:@"isSended"];
    }
    
    return self;
}

@end

