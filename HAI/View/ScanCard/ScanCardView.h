//
//  ScanCardView.h
//  HAI
//
//  Created by Dung Do on 10/11/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@protocol ScanCardViewDelegate <NSObject>

- (void)didScanCard:(NSString *)result;

@end

@interface ScanCardView : BaseView

@property (weak, nonatomic) id<ScanCardViewDelegate> delegate;
@property (strong,nonatomic) NSMutableArray *arrCodes;
@property (strong, nonatomic) IBOutlet UIView *viewScan;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;

@end

