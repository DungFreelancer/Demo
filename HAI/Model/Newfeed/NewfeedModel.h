//
//  NewfeedModel.h
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewfeedModel : NSObject <NSCoding>

@property (strong, nonatomic) NSString *newfeedID;
@property (nonatomic) BOOL isReaded;

@end
