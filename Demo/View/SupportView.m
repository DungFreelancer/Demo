//
//  SupportView.m
//  Demo
//
//  Created by Dung Do on 11/13/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SupportView.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "CALayer+BorderShadow.h"
#import "Constant.h"

@implementation SupportView {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    
    // Setup button & text view.
    [self.btnSendRequest.layer setShadowWithRadius:1.0f];
    [self.btnSendRequest.layer setBorderWithColor:self.btnSendRequest.tintColor.CGColor];
    
    [self.txtComment.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    [self.txtComment setTextColor:[UIColor lightGrayColor]];
    self.txtComment.delegate = self;
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (IBAction)onClickStatus:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *) sender;
    if (seg.selectedSegmentIndex == 0) {
        DLOG(@"00000");
    } else if (seg.selectedSegmentIndex == 1) {
        DLOG(@"11111");
    }
}

- (IBAction)onClickSendRequest:(id)sender {
    
}

// MARK: - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Nội dung"]) {
        textView.text = @"";
        [textView setTextColor:[UIColor darkTextColor]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Nội dung";
        [textView setTextColor:[UIColor lightGrayColor]];
    }
}

// MARK: - UIGestureRecognizerDelegate
-(void)handleSingleTapGesture {
    [self.txtComment resignFirstResponder];
}

@end
