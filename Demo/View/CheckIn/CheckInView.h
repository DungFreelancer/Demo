//
//  Sec.h
//  Demo
//
//  Created by Dung Do on 9/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"
#import <CoreLocation/CoreLocation.h>

@interface CheckInView : BaseView <UINavigationControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgPicture;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePicture;
@property (weak, nonatomic) IBOutlet UIButton *btnHistory;

@property (weak, nonatomic) IBOutlet UIButton *onClickTakePicture;
@property (weak, nonatomic) IBOutlet UIButton *onClickCheckIn;

@end
