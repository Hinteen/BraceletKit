//
//  CameraViewController.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 04/12/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <BKDeviceDelegate>

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    [[BKDevice currentDevice] requestCameraMode:YES completion:^{
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[BKServices sharedInstance] unRegisterDeviceDelegate:self];
    [[BKDevice currentDevice] requestCameraMode:NO completion:^{
        
    } error:^(NSError *error) {
        
    }];
}

/**
 手环点击了拍照
 */
- (void)deviceDidTappedTakePicture{
    [self takePicture];
}



@end
