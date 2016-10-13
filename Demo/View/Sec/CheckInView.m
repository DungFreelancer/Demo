//
//  Sec.m
//  Demo
//
//  Created by Dung Do on 9/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "CheckInView.h"
#import "SWRevealViewController.h"
#import "AFNHelper.h"
#import "UtilityClass.h"
#import "Constant.h"

// MARK: CheckInModel
@interface CheckInModel : NSObject <NSCoding>
@property(nonatomic,strong)NSString *store;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *sender;
@property(nonatomic,strong)UIImage *image;
@end

@implementation CheckInModel
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.store forKey:@"store"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:UIImageJPEGRepresentation(self.image, 1.0) forKey:@"image"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.store = [aDecoder decodeObjectForKey:@"store"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.sender = [aDecoder decodeObjectForKey:@"sender"];
        self.image = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"image"]];
    }
    
    return self;
}
@end

// MARK: CheckInViewModel
@interface CheckInViewModel : NSObject 
@property(nonatomic, strong)NSMutableArray<CheckInModel *> *arrCheckIn;
- (id)init;
- (void)loadCheckIns;
- (void)saveCheckIns;
@end

@implementation CheckInViewModel
@synthesize arrCheckIn;

-(id)init{
    if((self = [super init])){
        arrCheckIn = [[NSMutableArray<CheckInModel *> alloc] init];
        [self loadCheckIns];
    }
    return self;
}

- (void)loadCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"temp.plist" ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        arrCheckIn = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)saveCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"temp.plist" ];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: arrCheckIn];
    [data writeToFile:path atomically:TRUE];
}

- (void)clearCheckIns {
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[UtilityClass sharedInstance] applicationDocumentDirectoryString], @"temp.plist" ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
        [arrCheckIn removeAllObjects];
    }
}

@end

// MARK: CheckInView
@interface CheckInView ()

@end

@implementation CheckInView {
    CheckInViewModel *ciViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ciViewModel = [[CheckInViewModel alloc] init];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.siderbarButton setTarget: self.revealViewController];
        [self.siderbarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.txtStore.delegate = self;
    self.txtContent.delegate = self;
    self.txtSender.delegate = self;
    
    // Border button
    self.btnCheckIn.layer.cornerRadius = 5;
    self.btnCheckIn.layer.borderWidth = 1;
    self.btnCheckIn.layer.borderColor = self.btnCheckIn.tintColor.CGColor;
    self.btnCheckIn.layer.masksToBounds = true;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status > 0) {
            [ciViewModel loadCheckIns];
            for (CheckInModel *ci in ciViewModel.arrCheckIn) {
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:ci.store forKey:PARAM_NAME];
                [params setObject:ci.content forKey:PARAM_CONTENT];
                [params setObject:ci.sender forKey:PARAM_User];
                
                [[AFNHelper sharedInstance] request:API_CHECK_IN paramaters:params image:ci.image completion:nil];
            }
            [ciViewModel clearCheckIns];
        }
    }];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (IBAction)takeAPicture:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = TRUE;
    [self presentViewController:imagePickerController animated:TRUE completion:nil];
}

- (IBAction)checkIn:(UIButton *)sender {
    
    if ([[UtilityClass sharedInstance] connected]) {
        // Push data to Service.
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:self.txtStore.text forKey:PARAM_NAME];
        [params setObject:self.txtContent.text forKey:PARAM_CONTENT];
        [params setObject:self.txtSender.text forKey:PARAM_User];
        
        [[AFNHelper sharedInstance] request:API_CHECK_IN paramaters:params image:self.imgAvatar.image completion:^(id response, NSError *error) {
            DLOG(@"respone=%@", response);
            if ([[response valueForKey:@"success"] boolValue]) {
                [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:@"Success" andMessage:@"Check in complete." andButton:@"OK"];
            } else {
                [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:@"Fail" andMessage:@"Can't check in." andButton:@"OK"];
            }
        }];
    } else {
        [[UtilityClass sharedInstance] showAlertOnViewController:self withTitle:@"Success" andMessage:@"Check in complete." andButton:@"OK"];
        // Store to database
        CheckInModel *a = [[CheckInModel alloc] init];
        a.store = self.txtStore.text;
        a.content = self.txtContent.text;
        a.sender = self.txtSender.text;
        a.image = self.imgAvatar.image;
        [ciViewModel.arrCheckIn addObject:a];
        [ciViewModel saveCheckIns];
    }
}

// UIImagePickerControllerDelegate.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.imgAvatar setImage:[info valueForKey:UIImagePickerControllerEditedImage]];
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}

// UITextFieldDelefate.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
