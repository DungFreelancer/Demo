//
//  AgencyView.h
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@interface AgencyView : BaseView <UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    UISearchController *txtSearch;
}

@property (weak, nonatomic) IBOutlet UITableView *tbAgency;

@end
