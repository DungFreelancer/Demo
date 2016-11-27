//
//  CheckInViewModel.m
//  Demo
//
//  Created by Dung Do on 10/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckInViewModel.h"
#import "UtilityClass.h"

@implementation CheckInViewModel

- (id)init{
    if ((self = [super init])){
        self.arrCheckIn = [[NSMutableArray<CheckInModel *> alloc] init];
        [self loadCheckIns];
    }
    return self;
}

- (void)loadCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"CheckIn.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.arrCheckIn = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)saveCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"CheckIn.plist"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self.arrCheckIn];
    [data writeToFile:path atomically:YES];
}

- (void)clearCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"CheckIn.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
        [self.arrCheckIn removeAllObjects];
    }
}

- (int)numberOfUnsended {
    int count = 0;
    for (int i = 0; i < self.arrCheckIn.count; ++i) {
        if (!self.arrCheckIn[i].isSended) {
            ++count;
        }
    }
    
    return count;
}

@end
