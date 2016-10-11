//
//  SidebarViewController.m
//  TemplateObjC
//
//  Created by Dung Do on 9/19/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "UIView+RoundedCorners.h"
#import "UIImageView+Download.h"
#import "Constant.h"

@interface SidebarViewController () {
    NSArray *menuItems;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation SidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    
    menuItems = @[@"Staff Information", @"Check In"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
