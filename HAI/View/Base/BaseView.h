//
//  Base.h
//  HAI
//
//  Created by Dung Do on 9/27/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIViewController {
    
}

-(void)setNavBarTitle:(NSString *)title;
-(void)setBackBarItem;
- (void)scrollToBottomOnTableView:(UITableView *)tableView;

@end
