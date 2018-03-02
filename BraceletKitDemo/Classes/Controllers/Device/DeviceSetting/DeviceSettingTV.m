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
#import "BKDescriptionUtilities.h"
#import "BKHourBucketPicker.h"

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
    if (!device) {
        return;
    }
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
            row.title = @"日期格式";
            row.target = @"dateFormat";
            row.detail = [BKDescriptionUtilities dateFormatDescription:device.preferences.dateFormat];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"时间格式";
            row.target = @"hourFormat";
            row.detail = [BKDescriptionUtilities hourFormatDescription:device.preferences.hourFormat];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"温度单位";
            row.target = @"temperature_unit";
            row.detail = [BKDescriptionUtilities tempUnitDescription:device.preferences.temperatureUnit];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"公英制单位";
            row.target = @"distance_unit";
            if (device.preferences.distanceUnit == BKDistanceUnitImperial) {
                row.detail = @"英制";
            } else {
                row.detail = @"公制";
            }
        }];
        if ([device.functions containsObject:@(BKDeviceFunctionWristBlight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"抬腕亮屏";
                row.target = @"switch.wrist_blight";
            }];
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"抬腕亮屏时段";
                row.target = @"wrist_blight_time";
                if (device.preferences.wristBlightStart > 0 || device.preferences.wristBlightEnd > 0) {
                    row.detail = [NSString stringWithFormat:@"%d:00 ~ %d:00", (int)device.preferences.wristBlightStart, (int)device.preferences.wristBlightEnd];
                } else {
                    row.detail = @"全天支持";
                }
            }];
        }
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"自动运动识别";
            row.target = @"switch.auto_sport";
        }];
        if ([device.functions containsObject:@(BKDeviceFunctionAutoHeartRate)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"自动心率监测";
                row.target = @"switch.auto_hr";
            }];
        }
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"自动睡眠识别";
            row.target = @"switch.auto_sleep";
        }];
        if ([device.functions containsObject:@(BKDeviceFunctionExerciseHRWarning)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"运动心率报警设置";
                row.target = @"ExerciseHRWarning";
            }];
        }
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"断连提醒";
            row.target = @"switch.disconnect_tip";
        }];
        if ([device.functions containsObject:@(BKDeviceFunctionLedLight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"LED开关";
                row.target = @"switch.led";
            }];
        }
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"advertisement开关";
            row.target = @"switch.advertisement";
        }];
        
        if ([device.functions containsObject:@(BKDeviceFunctionBackgroundLight)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"背光颜色";
                row.target = @"backlight";
                row.detail = [BKDescriptionUtilities bgColorDescription:device.preferences.backgroundColor];
            }];
        }
        
        if ([device.functions containsObject:@(BKDeviceFunctionMotorControl)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"振动设置";
                row.target = @"motor_setting";
            }];
        }
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"勿扰模式设置";
            row.target = @"dnd_mode";
        }];
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"语言";
            row.target = @"language";
            row.detail = [BKDescriptionUtilities languageDescription:device.preferences.language];
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
            row.title = @"智拍";
            row.target = @"zhipai";
        }];
        
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"久坐提醒";
            row.target = @"sedentariness";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日程提醒";
            row.target = @"schedule";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"闹钟";
            row.target = @"alarm_clock";
        }];
        
        
        if ([device.functions containsObject:@(BKDeviceFunctionWeather)]) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"更新天气";
                row.target = @"weather";
            }];
        }
        
        
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"提醒手环和系统解绑";
            row.target = @"noti_unbind";
        }];
        
        
    }];
    
    dataSource(dataList);
    
}

- (void)ax_tableViewCell:(AXTableViewCellType *)cell willSetModel:(AXTableRowModelType *)model forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    model.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([model.target containsString:@"switch."]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *sw = [[UISwitch alloc] init];
        cell.accessoryView = sw;
        if ([model.target isEqualToString:@"switch.wrist_blight"]) {
            sw.on = [BKDevice currentDevice].preferences.wristSwitch;
            [sw ax_addValueChangedHandler:^(__kindof UISwitch * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.wristSwitch = sender.on;
                }];
            }];
        } else if ([model.target isEqualToString:@"switch.auto_sport"]) {
            sw.on = [BKDevice currentDevice].preferences.autoSport;
            [sw ax_addValueChangedHandler:^(__kindof UISwitch * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.autoSport = sender.on;
                }];
            }];
        } else if ([model.target isEqualToString:@"switch.auto_hr"]) {
            sw.on = [BKDevice currentDevice].preferences.autoHeartRate;
            [sw ax_addValueChangedHandler:^(__kindof UISwitch * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.autoHeartRate = sender.on;
                }];
            }];
        } else if ([model.target isEqualToString:@"switch.auto_sleep"]) {
            sw.on = [BKDevice currentDevice].preferences.autoSleep;
            [sw ax_addValueChangedHandler:^(__kindof UISwitch * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.autoSleep = sender.on;
                }];
            }];
        } else if ([model.target isEqualToString:@"switch.disconnect_tip"]) {
            sw.on = [BKDevice currentDevice].preferences.disconnectTip;
            [sw ax_addValueChangedHandler:^(__kindof UISwitch * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.disconnectTip = sender.on;
                }];
            }];
        } else if ([model.target isEqualToString:@"switch.led"]) {
            sw.on = [BKDevice currentDevice].preferences.ledSwitch;
            [sw ax_addValueChangedHandler:^(__kindof UISwitch * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.ledSwitch = sender.on;
                }];
            }];
        } else if ([model.target isEqualToString:@"switch.advertisement"]) {
            sw.on = [BKDevice currentDevice].preferences.advertisementSwitch;
            [sw ax_addValueChangedHandler:^(__kindof UISwitch * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.advertisementSwitch = sender.on;
                }];
            }];
        }
    }
    
}


- (void)ax_tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self tableViewRowModelForIndexPath:indexPath];
    if ([model.target isEqualToString:@"zhipai"]) {
        CameraViewController *vc = [[CameraViewController alloc] init];
        [self.controller presentViewController:vc animated:YES completion:nil];
        
    } else if ([model.target isEqualToString:@"pushstring"]) {
        [UIAlertController ax_showAlertWithTitle:@"推送字符串" message:@"" actions:^(UIAlertController * _Nonnull alert) {
            __block UITextField *tf;
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                tf = textField;
                tf.returnKeyType = UIReturnKeySend;
                textField.placeholder = @"DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME DID YOU MISS ME";
                [textField ax_addEditingEndOnExitHandler:^(__kindof UITextField * _Nonnull sender) {
                    [[BKDevice currentDevice] requestPushMessage:tf.text.length?tf.text:tf.placeholder completion:nil error:nil];
                }];
            }];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                if (tf) {
                    [tf endEditing:YES];
                    [[BKDevice currentDevice] requestPushMessage:tf.text.length?tf.text:tf.placeholder completion:nil error:nil];
                }
            }];
            [alert ax_addCancelAction];
        }];
        
    } else if ([model.target isEqualToString:@"noti_unbind"]) {
        [[BKServices sharedInstance].connector disConnectDevice];
    }
    else if ([model.target isEqualToString:@"dateFormat"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities dateFormatDescription:BKDateFormatMMDD] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.dateFormat = BKDateFormatMMDD;
                }];
            }];
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities dateFormatDescription:BKDateFormatDDMM] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.dateFormat = BKDateFormatDDMM;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    else if ([model.target isEqualToString:@"hourFormat"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities hourFormatDescription:BKHourFormat12] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.hourFormat = BKHourFormat12;
                }];
            }];
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities hourFormatDescription:BKHourFormat24] handler:^(UIAlertAction * _Nonnull sender) {
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
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities tempUnitDescription:BKTemperatureUnitCentigrade] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.temperatureUnit = BKTemperatureUnitCentigrade;
                }];
            }];
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities tempUnitDescription:BKTemperatureUnitFahrenheit] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.temperatureUnit = BKTemperatureUnitFahrenheit;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    else if ([model.target isEqualToString:@"distance_unit"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities distanceUnitDescription:BKDistanceUnitMetric] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.distanceUnit = BKDistanceUnitMetric;
                }];
            }];
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities distanceUnitDescription:BKDistanceUnitImperial] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.distanceUnit = BKDistanceUnitImperial;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    else if ([model.target isEqualToString:@"backlight"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities bgColorDescription:BKDeviceBGColorBlack] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.backgroundColor = BKDeviceBGColorBlack;
                }];
            }];
            [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities bgColorDescription:BKDeviceBGColorWhite] handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.backgroundColor = BKDeviceBGColorWhite;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    
    else if ([model.target isEqualToString:@"wrist_blight_time"]) {
        NSString *title = [NSString stringWithFormat:@"设置%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:@"\n\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            BKHourBucketPicker *picker = [[BKHourBucketPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                NSInteger start = [picker selectedRowInComponent:0];
                NSInteger end = [picker selectedRowInComponent:1];
                [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                    preferences.wristBlightStart = start;
                    preferences.wristBlightEnd = end;
                }];
            }];
            
            [alert ax_addCancelAction];
        }];
    }
    
    
    else if ([model.target isEqualToString:@"language"]) {
        NSString *title = [NSString stringWithFormat:@"切换%@", model.title];
        [UIAlertController ax_showActionSheetWithTitle:title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [[BKDevice currentDevice].languages enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [alert ax_addDefaultActionWithTitle:[BKDescriptionUtilities languageDescription:obj.integerValue] handler:^(UIAlertAction * _Nonnull sender) {
                    [[BKDevice currentDevice].preferences transaction:^(BKPreferences *preferences) {
                        preferences.language = [BKDescriptionUtilities languageWithDescription:sender.title];
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
    
    else if ([model.target isEqualToString:@"weather"]) {
        [UIAlertController ax_showActionSheetWithTitle:model.title message:nil actions:^(UIAlertController * _Nonnull alert) {
            [alert ax_addDefaultActionWithTitle:@"晴 25 PM 28" handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice] requestUpdateWeatherInfo:^(BKWeather * _Nonnull weather) {
                    weather.condition = BKWeatherConditionFine;
                    weather.temperature = 25;
                    weather.unit = [BKDevice currentDevice].preferences.temperatureUnit;
                    weather.pm2_5 = 28;
                } completion:nil error:nil];
            }];
            [alert ax_addDefaultActionWithTitle:@"阵雨 20 PM 20" handler:^(UIAlertAction * _Nonnull sender) {
                [[BKDevice currentDevice] requestUpdateWeatherInfo:^(BKWeather * _Nonnull weather) {
                    weather.condition = BKWeatherConditionShower;
                    weather.temperature = 20;
                    weather.unit = [BKDevice currentDevice].preferences.temperatureUnit;
                    weather.pm2_5 = 20;
                } completion:nil error:nil];
            }];
            [alert ax_addCancelAction];
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
