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
@synthesize arrCheckIn;

-(id)init{
    if((self = [super init])){
        arrCheckIn = [[NSMutableArray<CheckInModel *> alloc] init];
        [self loadCheckIns];
    }
    return self;
}

- (void)loadCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"temp.plist" ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        arrCheckIn = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)saveCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"temp.plist" ];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: arrCheckIn];
    [data writeToFile:path atomically:TRUE];
}

- (void)clearCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"temp.plist" ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
        [arrCheckIn removeAllObjects];
    }
}

- (int)numberOfUnsended {
    int count = 0;
    for (int i = 0; i < arrCheckIn.count; ++i) {
        if (!arrCheckIn[i].isSended) {
            ++count;
        }
    }
    
    return count;
}

@end
