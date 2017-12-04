//
//  CameraViewController.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 04/12/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <BraceletManager>

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
    [[BraceletManager sharedInstance] registerDelegate:self];
    [BraceletManager sharedInstance].cameraMode = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[BraceletManager sharedInstance] unRegisterDelegate:self];
    [BraceletManager sharedInstance].cameraMode = NO;
}

- (void)braceletDidTakePicture{
    [self takePicture];
}


@end
