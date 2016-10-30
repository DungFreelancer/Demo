//
//  Sec.h
//  Demo
//
//  Created by Dung Do on 9/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface CheckInView : BaseView <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtStore;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;
@property (weak, nonatomic) IBOutlet UITextField *txtSender;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;

- (IBAction)takeAPicture:(UIButton *)sender;
- (IBAction)checkIn:(UIButton *)sender;

@end
