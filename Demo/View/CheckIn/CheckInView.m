//
//  Sec.m
//  Demo
//
//  Created by Dung Do on 9/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckInView.h"
#import "NetworkHelper.h"
#import "CALayer+BorderShadow.h"
#import "UtilityClass.h"
#import "HUDHelper.h"
#import "CheckInViewModel.h"
#import "Constant.h"

@interface CheckInView ()

@end

@implementation CheckInView {
    CheckInViewModel *vmCheckIn;
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setBackBarItem];
    self.navigationController.navigationBarHidden = NO;
    
    // Setup for buttons & text view.
    [self.btnTakePicture.layer setShadowWithRadius:1.0f];
    [self.btnTakePicture.layer setBorderWithColor:self.btnTakePicture.tintColor.CGColor];
    [self.btnCheckIn.layer setShadowWithRadius:1.0f];
    [self.btnCheckIn.layer setBorderWithColor:self.btnCheckIn.tintColor.CGColor];
    
    [self.txtComment.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    [self.txtComment setTextColor:[UIColor lightGrayColor]];
    self.txtComment.delegate = self;
    
    [self.txtAgency.layer setBorderWithColor:[UIColor darkGrayColor].CGColor];
    self.txtAgency.delegate = self;
    
    // Handle single tap.
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    vmCheckIn = [[CheckInViewModel alloc] init];
    
    // Request get user's location.
    if ([CLLocationManager locationServicesEnabled]) {
        [self getLocation];
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:nil
                                                      andMessage:NSLocalizedString(@"CHECKIN_LOCATION", nil)
                                                   andMainButton:NSLocalizedString(@"OK", nil)
                                               CompletionHandler:^(UIAlertAction *action) {
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               }
                                                  andOtherButton:nil
                                               CompletionHandler:nil];
    }
}

- (IBAction)onClickTakePicture:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)onClickCheckIn:(UIButton *)sender {
    // GPS is off or be denied on app.
    if (![CLLocationManager locationServicesEnabled] ||
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:nil
                                                      andMessage:NSLocalizedString(@"CHECKIN_LOCATION", nil)
                                                   andMainButton:NSLocalizedString(@"OK", nil)
                                               CompletionHandler:^(UIAlertAction *action) {
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               }
                                                  andOtherButton:nil
                                               CompletionHandler:nil];
        return;
    }
    
    if ([self.imgPicture.image isEqual:[UIImage imageNamed:@"no_picture"]]) {
        ELOG(@"%@", NSLocalizedString(@"NO_PICTURE", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_PICTURE", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    if ([self.txtAgency.text isEqualToString:@""]) {
        ELOG(@"%@", NSLocalizedString(@"CHECKIN_NO_AGENCY", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"CHECKIN_NO_AGENCY", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSString *comment = [self.txtComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([comment isEqualToString:@"Nội dung"]) {
        ELOG(@"%@", NSLocalizedString(@"NO_COMMENT", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_COMMENT", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    if ([[NetworkHelper sharedInstance]  isConnected]) {
        // Push data to Service.
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@".jpg" forKey:PARAM_EXTENSION];
        [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
        [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
        
        [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
        
        [[NetworkHelper sharedInstance] requestPost:API_UPLOAD_IMAGE paramaters:params image:self.imgPicture.image completion:^(id response, NSError *error) {
            
            [[HUDHelper sharedInstance] hideLoading];
            if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                DLOG(@"%@", response);
                NSString *image = [response valueForKey:RESPONSE_MESSAGE];
                NSString *date = [[UtilityClass sharedInstance] DateToString:[NSDate date] withFormate:@"MM/dd/yyyy HH:mm"];
                CLLocationCoordinate2D coordinate = [self getLocation];
                NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
                NSString *longtitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
                
                [params setObject:image forKey:PARAM_IMAGE];
                [params setObject:self.txtAgency.text forKey:PARAM_AGENCY];
                [params setObject:self.txtComment.text forKey:PARAM_COMMENT];
                [params setObject:date forKey:PARAM_DATE];
                [params setObject:latitude forKey:PARAM_LATITUDE];
                [params setObject:longtitude forKey:PARAM_LONGTITUDE];
                
                [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
                
                [[NetworkHelper sharedInstance] requestPost:API_CHECK_IN paramaters:params completion:^(id response, NSError *error) {
                    
                    [[HUDHelper sharedInstance] hideLoading];
                    
                    if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                        DLOG(@"%@", response);
                        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                                       withTitle:nil
                                                                      andMessage:NSLocalizedString(@"CHECKIN_SUCCESS", nil)
                                                                       andButton:NSLocalizedString(@"OK", nil)];
                        [self saveLogCheckInWithSended:YES];
                        [self cleanAllView];
                    } else {
                        ELOG(@"%@", response);
                        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                                      andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"CHECKIN_FAIL", nil)
                                                                       andButton:NSLocalizedString(@"OK", nil)];
                    }
                }];
            } else {
                ELOG(@"%@", response);
                [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                               withTitle:NSLocalizedString(@"ERROR", nil)
                                                              andMessage:[response valueForKey:RESPONSE_MESSAGE] //NSLocalizedString(@"CHECKIN_FAIL", nil)
                                                               andButton:NSLocalizedString(@"OK", nil)];
            }
        }];
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:nil
                                                      andMessage:NSLocalizedString(@"CHECKIN_SAVE_OFFLINE", nil)
                                                       andButton:@"OK"];
        [self saveLogCheckInWithSended:NO];
        [self cleanAllView];
    }
}

- (void)saveLogCheckInWithSended:(BOOL)sended {
    CheckInModel *ci = [[CheckInModel alloc] init];
    
    ci.image = UIImageJPEGRepresentation(self.imgPicture.image, 1.0);
    ci.extension = @".jpg";
    ci.comment = self.txtComment.text;
    ci.date = [[UtilityClass sharedInstance] DateToString:[NSDate date] withFormate:@"MM/dd/yyyy HH:mm"];
    CLLocationCoordinate2D coordinate = [self getLocation];
    ci.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    ci.longtitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    ci.isSended = sended;
    
    [vmCheckIn loadCheckIns];
    [vmCheckIn.arrCheckIn addObject:ci];
    [vmCheckIn saveCheckIns];
}

- (CLLocationCoordinate2D)getLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
}

- (void)cleanAllView{
    self.imgPicture.image = [UIImage imageNamed:@"no_picture"];
    self.txtAgency.text = @"";
    self.txtComment.text = @"Chú thích";
    [self.txtComment setTextColor:[UIColor lightGrayColor]];
}

// UIImagePickerControllerDelegate.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.imgPicture setImage:[info valueForKey:UIImagePickerControllerEditedImage]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.txtComment &&
        [textView.text isEqualToString:@"Chú thích"]) {
        textView.text = @"";
        [textView setTextColor:[UIColor darkTextColor]];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *comment = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (textView == self.txtComment &&
        [comment isEqualToString:@""]) {
        textView.text = @"Chú thích";
        [textView setTextColor:[UIColor lightGrayColor]];
    }
}

// MARK: - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtAgency) {
        [self.txtAgency resignFirstResponder];
    }
    
    return YES;
}

// MARK: - UIGestureRecognizerDelegate
- (void)handleSingleTapGesture {
    [self.txtAgency resignFirstResponder];
    [self.txtComment resignFirstResponder];
}

@end
