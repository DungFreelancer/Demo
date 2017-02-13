//
//  AgencyView.h
//  HAI
//
//  Created by Dung Do on 12/20/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@protocol AgencyViewDelegate <NSObject>

- (void)didChooseAgency:(NSString *)code;

@end

@interface AgencyView : BaseView <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id<AgencyViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtAgency;
@property (weak, nonatomic) IBOutlet UITableView *tbAgency;

- (IBAction)onClickAgency:(id)sender;

@end
