//
//  DeviceVC.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 02/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "DeviceVC.h"
#import "DeviceSettingTV.h"
#import <AXCameraKit/AXCameraKit.h>
#import <AVFoundation/AVFoundation.h>

static inline CGSize contentSize(){
    return CGSizeMake(kScreenW, kScreenH - kTopBarHeight - kTabBarHeight);
}


@interface DeviceVC () <BKDeviceDelegate>

@end

@implementation DeviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    
    __weak typeof(self) weakSelf = self;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"band" action:^(UIBarButtonItem * _Nonnull sender) {
        [weakSelf.navigationController ax_pushViewControllerNamed:@"ScanViewController"];
    }];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ax_itemWithTitle:@"setting" action:^(UIBarButtonItem * _Nonnull sender) {
        [UIApplication ax_openAppSetting];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    [[BKServices sharedInstance] unRegisterDeviceDelegate:self];
}


- (AXTableViewType *)installTableView{
    return [[DeviceSettingTV alloc] initWithFrame:CGRectMake(0, 0, contentSize().width, contentSize().height) style:UITableViewStyleGrouped];
}


/**
 更新了设备信息
 */
- (void)deviceDidUpdateInfo{
    [self.tableView reloadDataSourceAndRefreshTableView];
}

/**
 更新了电池信息
 
 @param battery 电池电量
 */
- (void)deviceDidUpdateBattery:(NSInteger)battery{
    [self.tableView reloadDataSourceAndRefreshTableView];
}


/**
 手环点击了查找手机
 */
- (void)deviceDidTappedFindMyPhone{
    AudioServicesPlayAlertSound(1008);
}


@end

