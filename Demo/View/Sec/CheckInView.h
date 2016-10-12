//
//  Sec.h
//  Demo
//
//  Created by Dung Do on 9/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "Base.h"
#import <MTBBarcodeScanner/MTBBarcodeScanner.h>

@interface CheckInView : Base <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *siderbarButton;
@property (weak, nonatomic) IBOutlet UITextField *txtStore;
@property (weak, nonatomic) IBOutlet UITextField *txtContent;
@property (weak, nonatomic) IBOutlet UITextField *txtSender;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckIn;

- (IBAction)takeAPicture:(UIButton *)sender;
- (IBAction)checkIn:(UIButton *)sender;

@end
