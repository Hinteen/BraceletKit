//
//  CameraViewController.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 04/12/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <BKSessionDelegate>

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
    [[BKSession sharedInstance] registerDelegate:self];
    [[BKSession sharedInstance] requestCameraMode:YES completion:^{

    } error:^(NSError *error) {

    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[BKSession sharedInstance] unRegisterDelegate:self];
    [[BKSession sharedInstance] requestCameraMode:NO completion:^{
        
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
