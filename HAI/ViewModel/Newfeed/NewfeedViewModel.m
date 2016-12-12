//
//  NewfeedViewModel.m
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "NewfeedViewModel.h"
#import "UtilityClass.h"

@implementation NewfeedViewModel

- (id)init{
    if ((self = [super init])){
        self.arrNewfeed = [[NSMutableArray<NewfeedModel *> alloc] init];
        [self loadNewfeeds];
    }
    return self;
}

- (void)loadNewfeeds {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"Newfeed.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.arrNewfeed = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)saveNewfeeds {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"Newfeed.plist"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self.arrNewfeed];
    [data writeToFile:path atomically:YES];
}

- (void)clearNewfeeds {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"Newfeed.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
        [self.arrNewfeed removeAllObjects];
    }
}

@end
