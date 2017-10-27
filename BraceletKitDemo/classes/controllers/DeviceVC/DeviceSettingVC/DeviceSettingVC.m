//
//  DeviceSettingVC.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "DeviceSettingVC.h"
#import "DeviceSettingTV.h"
@interface DeviceSettingVC ()

@end

@implementation DeviceSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView<BaseTableView> *)installTableView{
    return [[DeviceSettingTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
}


@end
