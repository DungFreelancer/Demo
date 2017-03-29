//
//  NewfeedDetailView.m
//  HAI
//
//  Created by Dung Do on 12/12/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "NewfeedDetailView.h"
#import "UIImageView+Download.h"

@implementation NewfeedDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setBackBarItem];
    
    [self setContentView];
}

- (void)setContentView {
    self.lbTitle.text = self.titleNF;
    self.lbTime.text = self.timeNF;
    self.lbContent.text = self.contentNF;
    self.lbContent.editable = NO;
    [self.imgPhoto downloadFromURL:self.urlPhotoNF withPlaceholder:nil handleCompletion:^(BOOL success) {}];
    
    self.constraintHightContent.constant = self.lbContent.contentSize.height;
}

@end
