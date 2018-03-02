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
#import "BKBatteryView.h"
#import <MJRefresh.h>
#import "BKLanguageUtilities.h"


@interface DeviceSettingTV () 


@end

@implementation DeviceSettingTV

- (void)ax_tableViewDidLoadFinished:(UITableView<AXTableView> *)tableView{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __weak typeof(self) weakSelf = self;
        if ([BKDevice currentDevice]) {
            [[BKDevice currentDevice] requestUpdateBatteryCompletion:nil error:^(NSError * _Nonnull error) {
                [weakSelf.mj_header endRefreshing];
            }];
        } else {
            [weakSelf.mj_header endRefreshing];
        }
    }];
}

- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    BKDevice *device = [BKDevice currentDevice];

    AXTableModel *dataList = [[AXTableModel alloc] init];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"基本信息";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"设备名";
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
    }];
    
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"偏好设置";
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"时间格式";
            row.target = @"hourFormat";
            if (device.preferences.hourFormat == BKHourFormat12) {
                row.detail = @"12小时制";
            } else {
                row.detail = @"24小时制";
            }
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"温度单位";
            row.target = @"temperature_unit";
            if (device.preferences.temperatureUnit == BKTemperatureUnitFahrenheit) {
                row.detail = @"℉ 华氏度";
            } else {
                row.detail = @"℃ 摄氏度";
            }
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"语言";
            row.target = @"language";
            row.detail = [BKLanguageUtilities languageDescription:device.preferences.language];
        }];
    }];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"功能";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"更新时间";
            row.target = @"update time";
        }];
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
                row.title = @"3.日程";
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
                row.title = @"6.背光";
                row.target = @"hasBackgroundLightFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionLedLight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"7.LED灯";
                row.target = @"hasLedLightFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionAutoHeartRate)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"8.自动心率监测";
                row.target = @"hasAutoHeartRateFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionWristBlight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"9.抬腕亮屏";
                row.target = @"hasWristBlightFunction";
            }];
        }
        if ([device.functions containsObject:@(BKDeviceFunctionExerciseHRWarning)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"10.心率报警";
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
        [[BKDevice currentDevice] requestPushMessage:@"DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME" completion:^{
            
        } error:^(NSError * _Nonnull error) {
            
        }];
    } else if ([model.target isEqualToString:@"noti_unbind"]) {
        [[BKServices sharedInstance].connector disConnectDevice];
    }
    else if ([model.target isEqualToString:@"hourFormat"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:@"12小时制" handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.hourFormat = BKHourFormat12;
                }];
            }];
            [alert ax_addDefaultActionWithTitle:@"24小时制" handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.hourFormat = BKHourFormat24;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    else if ([model.target isEqualToString:@"temperature_unit"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:@"℃ 摄氏度" handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.temperatureUnit = BKTemperatureUnitCentigrade;
                }];
            }];
            [alert ax_addDefaultActionWithTitle:@"℉ 华氏度" handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.temperatureUnit = BKTemperatureUnitFahrenheit;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    else if ([model.target isEqualToString:@"language"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [[BKDevice currentDevice].languages enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [alert ax_addDefaultActionWithTitle:[BKLanguageUtilities languageDescription:obj.integerValue] handler:^(UIAlertAction * _Nonnull sender) {
                    [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                        preferences.language = [BKLanguageUtilities languageWithDescription:sender.title];
                    }];
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    else if ([model.target isEqualToString:@"update time"]) {
        [[BKDevice currentDevice] requestSyncTimeAtOnceCompletion:^{
            
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
