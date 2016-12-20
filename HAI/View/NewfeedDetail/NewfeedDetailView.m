//
//  NewfeedDetailView.m
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "NewfeedDetailView.h"

@implementation NewfeedDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    
    [self setContentView];
}

- (void)setContentView {
    self.lbTitle.text = self.title;
    self.lbTime.text = self.time;
    self.lbContent.text = self.content;
}

@end
