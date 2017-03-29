//
//  NewfeedDetailView.h
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface NewfeedDetailView : BaseView

@property (weak, nonatomic) NSString *titleNF;
@property (weak, nonatomic) NSString *timeNF;
@property (weak, nonatomic) NSString *contentNF;
@property (weak, nonatomic) NSString *urlPhotoNF;

@property (weak, nonatomic) IBOutlet UIScrollView *svNewfeed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHightContent;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UITextView *lbContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;

@end
