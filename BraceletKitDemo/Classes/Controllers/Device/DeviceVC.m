//
//  DeviceVC.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 02/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "DeviceVC.h"
#import "MyDevicesVC.h"
#import "DeviceSettingTV.h"
#import <AXCameraKit/AXCameraKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MJRefresh.h>


@interface DeviceVC () <BKDeviceDelegate, BKDataObserver>

@property (strong, nonatomic) DeviceSettingTV *tableView;

@end

@implementation DeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    [[BKServices sharedInstance] registerDataObserver:self];
    [self setupTableView];
    
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"nav_plus" action:^(UIBarButtonItem * _Nonnull sender) {
        if ([BKServices sharedInstance].connector.state == BKConnectStateConnected) {
            [UIAlertController ax_showAlertWithTitle:@"确定要与当前设备解绑，并绑定新的设备吗？" message:@"已经绑定过的设备可以点击左侧按钮进入[我的设备]页面直接切换设备。" actions:^(UIAlertController * _Nonnull alert) {
                [alert ax_addCancelActionWithTitle:@"取消" handler:nil];
                [alert ax_addDestructiveActionWithTitle:@"解绑并搜索新的设备" handler:^(UIAlertAction * _Nonnull sender) {
                    [[BKServices sharedInstance].connector disConnectDevice];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController ax_pushViewControllerNamed:@"ScanViewController"];
                    });
                }];
            }];
        } else {
            [weakSelf.navigationController ax_pushViewControllerNamed:@"ScanViewController"];
        }
    }];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"nav_list" action:^(UIBarButtonItem * _Nonnull sender) {
        [weakSelf.navigationController ax_pushViewControllerNamed:@"MyDevicesVC"];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    [[BKServices sharedInstance] unRegisterDeviceDelegate:self];
    [[BKServices sharedInstance] unRegisterDataObserver:self];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([BKServices sharedInstance].connector.state != BKConnectStateConnected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
}


- (void)setupTableView{
    
    self.tableView = [[DeviceSettingTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
}


/**
 更新了设备信息
 */
- (void)deviceDidUpdateInfo{
    [self.tableView reloadDataSourceAndRefreshTableView];
    [self.tableView.mj_header endRefreshing];
}

/**
 更新了电池信息
 
 @param battery 电池电量
 */
- (void)deviceDidUpdateBattery:(NSInteger)battery{
    [self.tableView reloadDataSourceAndRefreshTableView];
    [self.tableView.mj_header endRefreshing];
}


/**
 手环点击了查找手机
 */
- (void)deviceDidTappedFindMyPhone{
    AudioServicesPlayAlertSound(1008);
}

- (void)preferencesDidUpdated:(BKPreferences *)preferences{
    [self.tableView reloadDataSourceAndRefreshTableView];
}


@end

