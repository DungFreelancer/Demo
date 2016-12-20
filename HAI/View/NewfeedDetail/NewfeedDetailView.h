//
//  NewfeedDetailView.h
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface NewfeedDetailView : BaseView

@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *time;
@property (weak, nonatomic) NSString *content;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UITextView *lbContent;

@end
