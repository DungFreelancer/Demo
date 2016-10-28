//
//  ScanCardView.h
//  Demo
//
//  Created by Dung Do on 10/11/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@protocol ScanCardViewDelegate <NSObject>

- (void)didScanCard:(NSString *)result;

@end

@interface ScanCardView : BaseView

@property (strong, nonatomic) IBOutlet UIView *viewScan;
@property (weak, nonatomic) id<ScanCardViewDelegate> delegate;

@end

