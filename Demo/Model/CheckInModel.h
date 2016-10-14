//
//  CheckInModel.h
//  Demo
//
//  Created by Dung Do on 10/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInModel : NSObject <NSCoding>

@property(nonatomic,strong)NSString *store;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *sender;
@property(nonatomic,strong)NSData *image;

@end
