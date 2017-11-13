//
//  HomeVC.m
//  Hinteen
//
//  Created by xaoxuu on 07/09/2017.
//  Copyright © 2017 hinteen. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableView.h"
#import <AXKit/AXKit.h>
#import "DeviceSettingTV.h"
#import <AXCameraKit/AXCameraKit.h>

static inline CGSize contentSize(){
    return CGSizeMake(kScreenW, kScreenH - kTopBarHeight - kTabBarHeight);
}

@interface HomeVC () <BraceletManager>


//@property (strong, nonatomic) DeviceSettingTV *tableView;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    
    [self loadCameraKit];
    
    [[BraceletManager sharedInstance] registerDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[BraceletManager sharedInstance] unRegisterDelegate:self];
}


- (AXTableViewType *)installTableView{
    return [[DeviceSettingTV alloc] initWithFrame:CGRectMake(0, 0, contentSize().width, contentSize().height) style:UITableViewStyleGrouped];
}


- (void)braceletDidUpdateDeviceInfo:(ZeronerDeviceInfo *)deviceInfo{
    [self.tableView reloadDataSourceAndTableView];
}

- (void)braceletDidUpdateDeviceBattery:(ZeronerDeviceInfo *)deviceInfo{
    [self.tableView reloadDataSourceAndTableView];
}

- (void)cameraDidDismissed{
    [BraceletManager sharedInstance].cameraMode = NO;
}

- (void)cameraDidPresented{
    [BraceletManager sharedInstance].cameraMode = YES;
}

- (void)braceletDidTakePicture{
    [self takePicture];
}



@end
