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


- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    ZeronerBlePeripheral *peripheral = [BraceletManager sharedInstance].bindDevices.firstObject;
    ZeronerDeviceInfo *deviceInfo = [BraceletManager sharedInstance].currentDeviceInfo;
    
    AXTableModel *dataList = [[AXTableModel alloc] init];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"基本信息";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"手环名";
            row.detail = peripheral.deviceName;
            row.target = @"BraceletNameVC";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"UUID";
            row.detail = peripheral.uuidString;
            row.target = @"UUIDVC";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"电量";
            row.detail = [NSString stringWithFormat:@"%d%%", (int)deviceInfo.batLevel];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"model";
            row.detail = deviceInfo.model;
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"协议版本";
            row.detail = deviceInfo.protocolVer;
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"版本";
            row.detail = deviceInfo.version;
            row.target = @"version";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"OAD";
            row.detail = NSStringFromNSInteger(deviceInfo.oadMode);
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"序列号";
            row.detail = deviceInfo.seriesNo;
            row.target = @"seriesNo";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"蓝牙地址";
            row.detail = deviceInfo.bleAddr;
            row.target = @"bleAddr";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"hw版本";
            row.detail = NSStringFromNSInteger(deviceInfo.hwVersion);
        }];
    }];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"功能";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"推送消息";
            row.target = @"pushstring";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"1.智拍";
            row.target = @"zhipai";
        }];
        if ([BraceletManager sharedInstance].bleSDK.hasHeartFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"2.心率";
                row.target = @"xinlv";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasScheduleFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"3.schedule";
                row.target = @"schedule";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasWeatherFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"4.天气";
                row.target = @"weather";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasMotorControlFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"5.振动";
                row.target = @"motor";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasBackgroundLightFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"6.hasBackgroundLightFunction";
                row.target = @"hasBackgroundLightFunction";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasLedLightFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"7.hasLedLightFunction";
                row.target = @"hasLedLightFunction";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasAutoHeartRateFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"8.hasAutoHeartRateFunction";
                row.target = @"hasAutoHeartRateFunction";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasWristBlightFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"9.hasWristBlightFunction";
                row.target = @"hasWristBlightFunction";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasExerciseHRWarningFunction) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"10.hasExerciseHRWarningFunction";
                row.target = @"hasExerciseHRWarningFunction";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasSimpleLanguage) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"11.hasSimpleLanguage";
                row.target = @"hasSimpleLanguage";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasJapaneseLanguage) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"12.hasJapaneseLanguage";
                row.target = @"hasJapaneseLanguage";
            }];
        }
        if ([BraceletManager sharedInstance].bleSDK.hasItalianLanguage) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"13.hasItalianLanguage";
                row.target = @"hasItalianLanguage";
            }];
        }
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"提醒手环和系统解绑";
            row.target = @"noti_unbind";
        }];
        
        
    }];
    
    dataSource(dataList);
    
}


- (void)ax_tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self tableViewRowModelForIndexPath:indexPath];
    if ([model.target isEqualToString:@"zhipai"]) {
        [self.controller presentCameraVC:^{
            
        }];
    } else if ([model.target isEqualToString:@"pushstring"]) {
        [[BraceletManager sharedInstance].bleSDK pushStr:@"DID YOU MISS ME"];
    } else if ([model.target isEqualToString:@"noti_unbind"]) {
        [[BraceletManager sharedInstance] disConnectDevice];
        
        
        
        
    }
    
    
    
    
    else if (model.target.length) {
        // @xaoxuu: push default vc
        DefaultViewController *vc = [DefaultViewController defaultVCWithTitle:NSLocalizedString(model.title, nil) detail:NSLocalizedString(model.detail, nil)];
        [self.controller.navigationController pushViewController:vc animated:YES];
    }
    
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.dataList.sections[section].headerTitle;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.dataList.sections[section].footerHeight;
}

@end
