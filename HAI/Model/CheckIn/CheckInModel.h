//
//  CheckInModel.h
//  HAI
//
//  Created by Dung Do on 10/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInModel : NSObject <NSCoding>

@property(nonatomic,strong)NSData *image;
@property(nonatomic,strong)NSString *extension;
@property(nonatomic,strong)NSString *agencyCode;
@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *latitude;
@property(nonatomic,strong)NSString *longtitude;
@property(nonatomic)BOOL isSended;

@end
