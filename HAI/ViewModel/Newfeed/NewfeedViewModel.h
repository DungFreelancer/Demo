//
//  NewfeedViewModel.h
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewfeedModel.h"

@interface NewfeedViewModel : NSObject

@property(nonatomic, strong) NSMutableArray<NewfeedModel *> *arrNewfeed;

- (id)init;
- (void)loadNewfeeds;
- (void)saveNewfeeds;
- (void)clearNewfeeds;

@end
