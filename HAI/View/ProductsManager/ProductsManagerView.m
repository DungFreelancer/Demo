//
//  ProductsManager.m
//  HAI
//
//  Created by Dung Do on 11/28/16.
//  Copyright © 2016 Dung Do. All rights reserved.
//

#import "ProductsManagerView.h"
#import "NetworkHelper.h"
#import "UtilityClass.h"
#import "Constant.h"
#import "HUDHelper.h"

@implementation ProductsManagerView {
    NSMutableArray<NSString *> *arrFuction;
}

// Mark: View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackBarItem];
    self.navigationController.navigationBarHidden = NO;
    
    self.clFunction.dataSource = self;
    self.clFunction.delegate = self;
    arrFuction = [[NSMutableArray alloc] initWithObjects:@"importproduct", @"savepoint", @"tracking", nil];
//    [self showMenu];
}

- (void)showMenu {
    if ([[NetworkHelper sharedInstance] isConnected] == NO) {
        ELOG(@"%@", NSLocalizedString(@"NO_INTERNET", nil));
        [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                       withTitle:NSLocalizedString(@"ERROR", nil)
                                                      andMessage:NSLocalizedString(@"NO_INTERNET", nil)
                                                       andButton:NSLocalizedString(@"OK", nil)];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[USER_DEFAULT objectForKey:PREF_USER] forKey:PARAM_USER];
    [params setObject:[USER_DEFAULT objectForKey:PREF_TOKEN] forKey:PARAM_TOKEN];
    
    [[HUDHelper sharedInstance] showLoadingWithTitle:NSLocalizedString(@"LOADING", nil) onView:self.view];
    [[NetworkHelper sharedInstance] requestPost:API_FUNCTION_PRODUCT paramaters:params completion:^(id response, NSError *error) {
        [[HUDHelper sharedInstance] hideLoading];
        
        if ([[response valueForKey:RESPONSE_ID] isEqualToString:@"1"]) {
            DLOG(@"%@", response);
            arrFuction = [response valueForKey:RESPONSE_FUNCTION];
            [self.clFunction reloadData];
        } else {
            ELOG(@"%@", response);
            [[UtilityClass sharedInstance] showAlertOnViewController:self
                                                           withTitle:NSLocalizedString(@"ERROR", nil)
                                                          andMessage:[response valueForKey:RESPONSE_MESSAGE]
                                                           andButton:NSLocalizedString(@"OK", nil)];
        }
    }];
}

// Mark: UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrFuction.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:arrFuction[indexPath.row] forIndexPath:indexPath];
    
    return cell;
}

@end
