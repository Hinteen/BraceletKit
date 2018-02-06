//
//  HomeVC.m
//  Hinteen
//
//  Created by xaoxuu on 07/09/2017.
//  Copyright © 2017 hinteen. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableView.h"
#import "BKRefreshView.h"
#import "BKBatteryView.h"
#import "DeviceSettingTV.h"
#import <MJRefresh.h>


static inline CGSize contentSize(){
    return CGSizeMake(kScreenW, kScreenH - kTopBarHeight - kTabBarHeight);
}

@interface HomeVC () <BKDeviceDelegate, BKDataObserver>

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    
    
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    [[BKServices sharedInstance] registerDataObserver:self];
    
    [self setupRefreshView];
    
    [self setupBatteryView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadDataSourceAndRefreshTableView];
    if ([BKServices sharedInstance].connector.state != BKConnectStateConnected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[BKServices sharedInstance] unRegisterDeviceDelegate:self];
    [[BKServices sharedInstance] unRegisterDataObserver:self];
}

- (AXTableViewType *)installTableView{
    return [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, contentSize().width, contentSize().height) style:UITableViewStyleGrouped];
}

- (void)setupRefreshView{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ax_itemWithCustomView:[BKRefreshView sharedInstance] action:^(UIBarButtonItem * _Nonnull sender) {
        [[BKRefreshView sharedInstance] startAnimating];
        [[BKDevice currentDevice] requestUpdateBatteryCompletion:nil error:nil];
        [[BKDevice currentDevice] requestUpdateAllHealthDataCompletion:nil error:nil];
    }];
}
- (void)setupBatteryView{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithCustomView:[BKBatteryView sharedInstance] action:^(UIBarButtonItem * _Nonnull sender) {
        
    }];
}


/**
 更新了电池信息
 
 @param battery 电池电量
 */
- (void)deviceDidUpdateBattery:(NSInteger)battery{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BKBatteryView sharedInstance] updateBatteryPercent:(CGFloat)battery / 100.0f];
    });
}

- (void)deviceDidSynchronizing:(BOOL)synchronizing{
    if (!synchronizing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
}

- (void)dataDidUpdated:(__kindof BKData *)data{
    [self.tableView reloadDataSourceAndRefreshTableView];
}

@end
