//
//  SupportModel.h
//  HAI
//
//  Created by Dung Do on 11/27/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupportModel : NSObject <NSCoding>

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSString *date;

@end
