//
//  UserInformationView.h
//  Demo
//
//  Created by Dung Do on 12/2/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface UserInformationView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbType;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;
@property (weak, nonatomic) IBOutlet UILabel *lbBirthday;
@property (weak, nonatomic) IBOutlet UILabel *lbArea;
@property (weak, nonatomic) IBOutlet UILabel *lbUser;

@end
