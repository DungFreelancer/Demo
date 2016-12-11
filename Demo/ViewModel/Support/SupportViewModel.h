//
//  SupportViewModel.h
//  Demo
//
//  Created by Dung Do on 11/27/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupportModel.h"

@interface SupportViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<SupportModel *> *arrSupport;

- (id)init;
- (void)loadSupports;
- (void)saveSupports;
- (void)clearSupports;

@end
