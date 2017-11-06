//
//  DeviceSettingTV.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "DeviceSettingTV.h"
#import <BraceletKit/BraceletKit.h>
#import <AXKit/AXKit.h>
#import "DefaultViewController.h"
#import <AXCameraKit/AXCameraKit.h>

@interface DeviceSettingTV ()

@property (strong, nonatomic) ZeronerBlePeripheral *peripheral;

@property (strong, nonatomic) ZeronerDeviceInfo *deviceInfo;

@end

@implementation DeviceSettingTV


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
    }
    return self;
}

- (void)setupTableViewDataSource:(void (^)(NSMutableArray<BaseTableModelSection *> *))dataSource{
    ZeronerBlePeripheral *peripheral = [BraceletManager sharedInstance].bindDevices.firstObject;
    ZeronerDeviceInfo *deviceInfo = [BraceletManager sharedInstance].currentDeviceInfo;
    NSMutableArray<BaseTableModelSection *> *sections = [NSMutableArray array];
    BaseTableModelSection *sec0 = [BaseTableModelSection new];
    [sections addObject:sec0];
    sec0.header_title = @"基本信息";
    sec0.rowHeight = @"50";
    
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"手环名";
        row.desc = peripheral.deviceName;
        row.target = @"BraceletNameVC";
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"UUID";
        row.desc = peripheral.uuidString;
        row.target = @"UUIDVC";
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"电量";
        row.desc = [NSString stringWithFormat:@"%d%%", (int)deviceInfo.batLevel];
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"model";
        row.desc = deviceInfo.model;
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"协议版本";
        row.desc = deviceInfo.protocolVer;
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"版本";
        row.desc = deviceInfo.version;
        row.target = @"version";
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"OAD";
        row.desc = NSStringFromNSInteger(deviceInfo.oadMode);
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"序列号";
        row.desc = deviceInfo.seriesNo;
        row.target = @"seriesNo";
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"蓝牙地址";
        row.desc = deviceInfo.bleAddr;
        row.target = @"bleAddr";
    }];
    [sec0 addRow:^(BaseTableModelRow *row) {
        row.title = @"hw版本";
        row.desc = NSStringFromNSInteger(deviceInfo.hwVersion);
    }];
    
    BaseTableModelSection *sec1 = [BaseTableModelSection new];
    [sections addObject:sec1];
    sec1.header_title = @"功能";
    sec1.rowHeight = @"50";
    [sec1 addRow:^(BaseTableModelRow *row) {
        row.title = @"推送消息";
        row.target = @"pushstring";
    }];
    [sec1 addRow:^(BaseTableModelRow *row) {
        row.title = @"1.智拍";
        row.target = @"zhipai";
    }];
    if ([BraceletManager sharedInstance].bleSDK.hasHeartFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"2.心率";
            row.target = @"xinlv";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasScheduleFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"3.schedule";
            row.target = @"schedule";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasWeatherFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"4.天气";
            row.target = @"weather";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasMotorControlFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"5.振动";
            row.target = @"motor";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasBackgroundLightFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"6.hasBackgroundLightFunction";
            row.target = @"hasBackgroundLightFunction";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasLedLightFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"7.hasLedLightFunction";
            row.target = @"hasLedLightFunction";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasAutoHeartRateFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"8.hasAutoHeartRateFunction";
            row.target = @"hasAutoHeartRateFunction";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasWristBlightFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"9.hasWristBlightFunction";
            row.target = @"hasWristBlightFunction";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasExerciseHRWarningFunction) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"10.hasExerciseHRWarningFunction";
            row.target = @"hasExerciseHRWarningFunction";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasSimpleLanguage) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"11.hasSimpleLanguage";
            row.target = @"hasSimpleLanguage";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasJapaneseLanguage) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"12.hasJapaneseLanguage";
            row.target = @"hasJapaneseLanguage";
        }];
    }
    if ([BraceletManager sharedInstance].bleSDK.hasItalianLanguage) {
        [sec1 addRow:^(BaseTableModelRow *row) {
            row.title = @"13.hasItalianLanguage";
            row.target = @"hasItalianLanguage";
        }];
    }
    [sec1 addRow:^(BaseTableModelRow *row) {
        row.title = @"提醒手环和系统解绑";
        row.target = @"noti_unbind";
    }];
    
    dataSource(sections);
}


- (void)indexPath:(NSIndexPath *)indexPath didSelected:(__kindof BaseTableModelRow *)model{
    if ([model.target isEqualToString:@"zhipai"]) {
        [self.controller presentCameraVC:^{
            
        }];
    } else if ([model.target isEqualToString:@"pushstring"]) {
        [[BraceletManager sharedInstance].bleSDK pushStr:@"DID YOU MISS ME"];
    } else if ([model.target isEqualToString:@"noti_unbind"]) {
        [[BraceletManager sharedInstance].bleSDK debindFromSystem];
    }
    
    
    
    else if (model.target.length) {
        // @xaoxuu: push default vc
        DefaultViewController *vc = [DefaultViewController defaultVCWithTitle:NSLocalizedString(model.title, nil) detail:NSLocalizedString(model.desc, nil)];
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
}




@end
