//
//  AgencyView.h
//  Demo
//
//  Created by Dung Do on 11/14/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "BaseView.h"

@protocol AgencyViewDelegate <NSObject>

- (void) didGetAgency:(NSDictionary *)agency;

@end

@interface AgencyView : BaseView <UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    UISearchController *txtSearch;
}

@property (weak, nonatomic) IBOutlet UITableView *tbAgency;
@property (weak, nonatomic) id<AgencyViewDelegate> delegate;

@end
