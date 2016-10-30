//
//  Login.h
//  Demo
//
//  Created by Dung Do on 10/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface LoginView : BaseView

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

- (IBAction)onClickLogin:(id)sender;

@end
