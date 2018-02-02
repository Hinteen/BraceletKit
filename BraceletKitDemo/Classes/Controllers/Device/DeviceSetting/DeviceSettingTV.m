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
#import "CameraViewController.h"

@interface DeviceSettingTV () 


@end

@implementation DeviceSettingTV



- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    BKDevice *device = [BKDevice currentDevice];
//    ZeronerBlePeripheral *peripheral = [BraceletManager sharedInstance].bindDevices.firstObject;
//    ZeronerDeviceInfo *deviceInfo = [BraceletManager sharedInstance].currentDeviceInfo;
    
    AXTableModel *dataList = [[AXTableModel alloc] init];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"基本信息";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"手环名";
            row.detail = device.name;
            row.target = @"BraceletNameVC";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"UUID";
            row.detail = device.uuid;
            row.target = @"UUIDVC";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"电量";
            row.detail = [NSString stringWithFormat:@"%d%%", (int)device.battery];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"model";
            row.detail = device.model;
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"版本";
            row.detail = device.version;
            row.target = @"version";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"mac地址";
            row.detail = device.mac;
            row.target = @"bleAddr";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"更新时间";
            row.detail = @"time";
        }];
    }];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"测试";
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"12";
            row.target = @"12";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"24";
            row.target = @"24";
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
        if ([device.functions containsObject:@(BKDeviceFunctionHeartRate)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"2.心率";
                row.target = @"xinlv";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionSchedule)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"3.schedule";
                row.target = @"schedule";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionWeather)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"4.天气";
                row.target = @"weather";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionMotorControl)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"5.振动";
                row.target = @"motor";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionBackgroundLight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"6.hasBackgroundLightFunction";
                row.target = @"hasBackgroundLightFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionLedLight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"7.hasLedLightFunction";
                row.target = @"hasLedLightFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionAutoHeartRate)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"8.hasAutoHeartRateFunction";
                row.target = @"hasAutoHeartRateFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionWristBlight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"9.hasWristBlightFunction";
                row.target = @"hasWristBlightFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionExerciseHRWarning)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"10.hasExerciseHRWarningFunction";
                row.target = @"hasExerciseHRWarningFunction";
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
        CameraViewController *vc = [[CameraViewController alloc] init];
        [self.controller presentViewController:vc animated:YES completion:nil];
        
    } else if ([model.target isEqualToString:@"pushstring"]) {
        [[BKDevice currentDevice] pushMessage:@"DID YOU MISS ME" completion:^{
            
        } error:^(NSError * _Nonnull error) {
            
        }];
    } else if ([model.target isEqualToString:@"noti_unbind"]) {
        [[BKServices sharedInstance].connector disConnectDevice];
    }
    else if ([model.target isEqualToString:@"12"]) {
        [BKDevice currentDevice].preferences.hourFormat = BKHourFormat12;
        [[BKDevice currentDevice].preferences saveToDatabase];
        [[BKDevice currentDevice].preferences applyToMyDevice];
    }
    else if ([model.target isEqualToString:@"24"]) {
        [BKDevice currentDevice].preferences.hourFormat = BKHourFormat24;
        [[BKDevice currentDevice].preferences saveToDatabase];
        [[BKDevice currentDevice].preferences applyToMyDevice];
    }
    
    else if ([model.target isEqualToString:@"time"]) {
        [[BKDevice currentDevice] syncTimeAtOnceCompletion:^{
            
        } error:^(NSError * _Nonnull error) {
            
        }];
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
