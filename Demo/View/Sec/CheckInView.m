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
    CheckInViewModel *ciViewModel;
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setBackBarItem];
    
    // Request get user's location.
    if ([CLLocationManager locationServicesEnabled]) {
        [self getLocation];
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:@""
                                                      andMessage:NSLocalizedString(@"LOCATION_SERVICES", nil)
                                                   andMainButton:NSLocalizedString(@"OK", nil)
                                                  andOtherButton:nil
                                               CompletionHandler:^(UIAlertAction *action) {
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               }];
    }
    
    ciViewModel = [[CheckInViewModel alloc] init];
    
//    self.txtComment.delegate = self;
//    
//    // Setup button.
//    [self.btnTakePicture.layer setShadowWithRadius:1.0f];
//    [self.btnTakePicture.layer setBorderWithColor:self.btnTakePicture.tintColor.CGColor];
//    [self.btnCheckIn.layer setShadowWithRadius:1.0f];
//    [self.btnCheckIn.layer setBorderWithColor:self.btnCheckIn.tintColor.CGColor];
}

- (IBAction)onClickTakePicture:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = TRUE;
    [self presentViewController:imagePickerController animated:TRUE completion:nil];
}

- (IBAction)onClickCheckIn:(UIButton *)sender {
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
                NSString *image = [response valueForKey:RESPONSE_MESSAGE];
                NSString *date = [[UtilityClass sharedInstance] DateToString:[NSDate date] withFormate:@"MM/dd/yyyy HH:mm"];
                CLLocationCoordinate2D coordinate = [self getLocation];
                NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
                NSString *longtitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
                
                [params setObject:image forKey:PARAM_IMAGE];
                [params setObject:self.txtComment.text forKey:PARAM_COMMENT];
                [params setObject:date forKey:PARAM_DATE];
                [params setObject:latitude forKey:PARAM_LATITUDE];
                [params setObject:longtitude forKey:PARAM_LONGTITUDE];
                
                [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
                
                [[NetworkHelper sharedInstance] requestPost:API_CHECK_IN paramaters:params completion:^(id response, NSError *error) {
                    
                    [[HUDHelper sharedInstance] hideLoading];
                    
                    if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
                        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                                       withTitle:nil
                                                                      andMessage:NSLocalizedString(@"CHECKIN_SUCCESS", nil)
                                                                       andButton:NSLocalizedString(@"OK", nil)];
                    } else {
                        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                                      andMessage:NSLocalizedString(@"CHECKIN_FAIL", nil)
                                                                       andButton:NSLocalizedString(@"OK", nil)];
                    }
                }];
            } else {
                [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                               withTitle:NSLocalizedString(@"ERROR", nil)
                                                              andMessage:NSLocalizedString(@"CHECKIN_FAIL", nil)
                                                               andButton:NSLocalizedString(@"OK", nil)];
            }
        }];
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:@"Success"
                                                      andMessage:NSLocalizedString(@"CHECKIN_SAVE_OFFLINE", nil)
                                                       andButton:@"OK"];
        // Store to database.
        CheckInModel *ci = [[CheckInModel alloc] init];
        ci.image = UIImageJPEGRepresentation(self.imgPicture.image, 1.0);
        ci.extension = @".jpg";
        ci.comment = self.txtComment.text;
        ci.date = [[UtilityClass sharedInstance] DateToString:[NSDate date] withFormate:@"MM/dd/yyyy HH:mm"];
        CLLocationCoordinate2D coordinate = [self getLocation];
        ci.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        ci.longtitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        [ciViewModel.arrCheckIn addObject:ci];
        [ciViewModel saveCheckIns];
    }
}

- (CLLocationCoordinate2D) getLocation
{
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

// UIImagePickerControllerDelegate.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.imgPicture setImage:[info valueForKey:UIImagePickerControllerEditedImage]];
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}

// UITextFieldDelefate.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
