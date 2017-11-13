//
//  DeviceSettingVC.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "DeviceSettingVC.h"
#import "DeviceSettingTV.h"
#import <BraceletKit/BraceletKit.h>

@interface DeviceSettingVC () <BraceletManager>

//@property (strong, nonatomic) DeviceSettingTV *tableView;

@end

@implementation DeviceSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[BraceletManager sharedInstance] registerDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[BraceletManager sharedInstance] unRegisterDelegate:self];
}


- (UITableView<BaseTableView> *)installTableView{
    return [[DeviceSettingTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
}


//
//- (void)braceletDidUpdateDeviceInfo:(ZeronerDeviceInfo *)deviceInfo{
//    [self.tableView reloadDataSourceAndTableView];
//}
//
//- (void)braceletDidUpdateDeviceBattery:(ZeronerDeviceInfo *)deviceInfo{
//    [self.tableView reloadDataSourceAndTableView];
//}



@end
