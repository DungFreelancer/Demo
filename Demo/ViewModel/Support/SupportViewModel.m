//
//  SupportViewModel.m
//  Demo
//
//  Created by Dung Do on 11/27/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SupportViewModel.h"
#import "UtilityClass.h"

@implementation SupportViewModel

- (id)init{
    if ((self = [super init])) {
        self.arrSupport = [[NSMutableArray<SupportModel *> alloc] init];
        [self loadSupports];
    }
    
    return self;
}

- (void)loadSupports {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"Support.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.arrSupport = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)saveSupports {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"Support.plist"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self.arrSupport];
    [data writeToFile:path atomically:YES];
}

- (void)clearSupports {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"Support.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
        [self.arrSupport removeAllObjects];
    }
}

@end
