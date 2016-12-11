//
//  CheckInViewModel.h
//  HAI
//
//  Created by Dung Do on 10/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckInModel.h"

@interface CheckInViewModel : NSObject

@property(nonatomic, strong) NSMutableArray<CheckInModel *> *arrCheckIn;

- (id)init;
- (void)loadCheckIns;
- (void)saveCheckIns;
- (void)clearCheckIns;
- (int)numberOfUnsended;

@end
