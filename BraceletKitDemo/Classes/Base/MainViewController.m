//
//  MainViewController.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 06/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "MainViewController.h"
#import "BKRefreshView.h"
#import "BKBatteryView.h"

@interface MainViewController () <BKConnectDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[BKServices sharedInstance] registerConnectDelegate:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    [[BKServices sharedInstance] unRegisterConnectDelegate:self];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([BKDevice currentDevice]) {
        self.navigationItem.title = [BKDevice currentDevice].name;
    }
    [[BKRefreshView sharedInstance] updateState];
}


/**
 已连接设备
 
 @param device 设备
 */
- (void)connectorDidConnectedDevice:(BKDevice *)device{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.title = device.name;
        [[BKRefreshView sharedInstance] updateState];
    });
}

/**
 断开连接

 @param device 设备
 */
- (void)connectorDidUnconnectedDevice:(BKDevice *)device{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BKRefreshView sharedInstance] updateState];
        [BKBatteryView sharedInstance].alpha = 0.5;
    });
}



@end
