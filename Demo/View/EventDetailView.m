//
//  EventDetail.m
//  Demo
//
//  Created by Dung Do on 11/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "EventDetailView.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation EventDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    // Setup button
    [self.btnMessage.layer setShadowWithRadius:1.0f];
    [self.btnMessage.layer setBorderWithColor: self.btnMessage.tintColor.CGColor];
}

- (IBAction)onClickMessage:(id)sender {
}

@end
