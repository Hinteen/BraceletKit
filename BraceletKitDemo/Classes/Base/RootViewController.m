//
//  RootViewController.m
//  AXKit
//
//  Created by xaoxuu on 29/04/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "RootViewController.h"
#import <AXKit/StatusKit.h>


@interface RootViewController () <BKScanDelegate, BKConnectDelegate, BKDeviceDelegate>


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = axThemeManager.color.background;
    
    [[BKServices sharedInstance] registerScanDelegate:self];
    [[BKServices sharedInstance] registerConnectDelegate:self];
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    
    self.mainTabBarVC = [[BaseTabBarController alloc] init];
    [self addChildViewController:self.mainTabBarVC];
    [self.view addSubview:self.mainTabBarVC.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[BKServices sharedInstance] unRegisterScanDelegate:self];
    [[BKServices sharedInstance] unRegisterConnectDelegate:self];
    [[BKServices sharedInstance] unRegisterScanDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![NSUserDefaults ax_readBoolForKey:@"app.guided"]) {
        [UIAlertController ax_showAlertWithTitle:@"用户条款" message:@"本程序仅供轩霆科技(hinteen.com)内部使用，非轩霆员工请自觉卸载不要使用。" actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:@"同意" handler:^(UIAlertAction * _Nonnull sender) {
                [NSUserDefaults ax_setBool:YES forKey:@"app.guided"];
            }];
            [alert ax_addCancelActionWithTitle:@"不同意" handler:^(UIAlertAction * _Nonnull sender) {
                NSAssert(NO, @"不同意使用条款");
            }];
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 SDK发现设备
 
 @param device 设备
 */
- (void)scannerDidDiscoverDevice:(BKDevice *)device{
    NSString *msg = [NSString stringWithFormat:@"发现设备<%@>", device.name];
    dispatch_async(dispatch_get_main_queue(), ^{
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:1];
    });
}

/**
 CentralManager状态改变
 
 @param central CentralManager
 */
- (void)scannerForCentralManagerDidUpdateState:(CBCentralManager *)central{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            // on newer versions
            if (central.state == CBManagerStatePoweredOn) {
                [AXStatusBar showStatusBarMessage:@"蓝牙已打开" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:2];
            } else if (central.state == CBManagerStatePoweredOff) {
                [AXStatusBar showStatusBarMessage:@"蓝牙已关闭" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
            } else if (central.state == CBManagerStateUnauthorized) {
                [AXStatusBar showStatusBarMessage:@"未开启app使用蓝牙权限" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:15];
            } else {
                [AXStatusBar showStatusBarMessage:@"蓝牙不可用" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:15];
            }
        } else {
            // Fallback on earlier versions
            if (central.state == CBCentralManagerStatePoweredOn) {
                [AXStatusBar showStatusBarMessage:@"蓝牙可用" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:2];
            } else if (central.state == CBCentralManagerStatePoweredOff) {
                [AXStatusBar showStatusBarMessage:@"蓝牙已关闭" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
            } else if (central.state == CBCentralManagerStateUnauthorized) {
                [AXStatusBar showStatusBarMessage:@"未开启app使用蓝牙权限" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:15];
            } else {
                [AXStatusBar showStatusBarMessage:@"蓝牙不可用" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:15];
            }
        }
    });
    
}

/**
 CentralManager发现设备
 
 @param device 设备
 */
- (void)scannerForCentralManagerDidDiscoverDevice:(BKDevice *)device{
    
}




/**
 已连接设备
 
 @param device 设备
 */
- (void)connectorDidConnectedDevice:(BKDevice *)device{
    NSString *msg = [NSString stringWithFormat:@"已连接设备<%@>", device.name];
    dispatch_async(dispatch_get_main_queue(), ^{
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:2];
    });
}

/**
 已断开设备
 
 @param device 设备
 */
- (void)connectorDidUnconnectedDevice:(BKDevice *)device{
    NSString *msg = [NSString stringWithFormat:@"与设备<%@>的连接已断开", device.name];
    dispatch_async(dispatch_get_main_queue(), ^{
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:15];
    });
}

/**
 与设备连接失败
 
 @param device 设备
 */
- (void)connectorDidFailToConnectDevice:(BKDevice *)device{
    NSString *msg = [NSString stringWithFormat:@"尝试与设备<%@>的连接失败", device.name];
    dispatch_async(dispatch_get_main_queue(), ^{
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:15];
    });
}

/**
 连接超时
 */
- (void)connectorDidConnectTimeout{
    NSString *msg = [NSString stringWithFormat:@"连接超时"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:15];
    });
}

- (void)deviceDidUpdateSynchronizeProgress:(CGFloat)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        [AXStatusBar showStatusBarProgress:progress textColor:[UIColor whiteColor] backgroundColor:[UIColor md_lightGreen] duration:60];
        if (progress == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [AXStatusBar hideStatusBarProgressMessage];
            });
        }
    });
}

@end
