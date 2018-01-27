//
//  BKDefines.h
//  BraceletKit
//
//  Created by xaoxuu on 27/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 手环功能列表

 - BKDeviceFunctionLanguageSelection: 语言切换
 - BKDeviceFunctionBackgroundLight: 背景颜色
 - BKDeviceFunctionLedLight: LED灯
 - BKDeviceFunctionWristBlight: 翻腕亮屏
 - BKDeviceFunctionSchedule: 日程提醒
 - BKDeviceFunctionMotorControl: 振动控制
 - BKDeviceFunctionWeather: 天气
 - BKDeviceFunctionHeartRate: 心率
 - BKDeviceFunctionAutoHeartRate: 自动心率
 - BKDeviceFunctionExerciseHRWarning: 心率报警
 */
typedef NS_OPTIONS(NSUInteger, BKDeviceFunction) {
    BKDeviceFunctionLanguageSelection,
    BKDeviceFunctionBackgroundLight,
    BKDeviceFunctionLedLight,
    BKDeviceFunctionWristBlight,
    BKDeviceFunctionSchedule,
    BKDeviceFunctionMotorControl,
    BKDeviceFunctionWeather,
    BKDeviceFunctionHeartRate,
    BKDeviceFunctionAutoHeartRate,
    BKDeviceFunctionExerciseHRWarning,
};

/**
 查询单位
 
 - BKQueryUnitDaily: 每日数据
 - BKQueryUnitWeekly: 每周数据
 - BKQueryUnitMonthly: 每月数据
 - BKQueryUnitYearly: 每年数据
 */
typedef NS_ENUM(NSUInteger, BKQueryUnit) {
    BKQueryUnitDaily   = 1,
    BKQueryUnitWeekly  = 7,
    BKQueryUnitMonthly = 31,
    BKQueryUnitYearly  = 365,
};


/**
 计量单位
 
 - BKDistanceUnitMetric:   公制距离单位 km、meter、kg .国际制单位，如，千米 、米 、千克。
 - BKDistanceUnitImperial: 英制距离单位 feet、inch、pound .国际制单位，如，英尺 、英寸 、磅。
 */
typedef NS_ENUM(NSUInteger, BKDistanceUnit) {
    BKDistanceUnitMetric = 0,
    BKDistanceUnitImperial = 1,
};


/**
 24、12小时制
 
 - BKHourFormat24: 24小时制
 - BKHourFormat12: 12小时制
 */
typedef NS_ENUM(NSUInteger, BKHourFormat) {
    BKHourFormat24 = 0,
    BKHourFormat12 = 1,
};


/**
 日期格式
 
 - BKDateFormatMMDD: 月月/日日
 - BKDateFormatDDMM: 日日/月月
 */
typedef NS_ENUM(NSUInteger, BKDateFormat) {
    BKDateFormatMMDD = 0,
    BKDateFormatDDMM = 1,
};

typedef NS_ENUM(NSUInteger, BKLanguage) {
    BKLanguageDefault = 0, //default is english equal @code BKLanguageEnglish
    BKLanguageEnglish  DEPRECATED_ATTRIBUTE ,// some smartband did not support it ,use BKLanguageDefault if you don't want set in simple chinese.
    BKLanguageSimpleChinese = 1,
    BKLanguageItalian = 2,
    BKLanguageJapanese = 3,
    BKLanguageFrench = 4,
    BKLanguageGerman = 5,
    BKLanguagePortugal = 6,
    BKLanguageSpanish = 7,
    BKLanguageRussian = 8,
    BKLanguageKorean = 9,
    BKLanguageArabic = 10,
    BKLanguageVietnamese = 11,
    BKLanguageSimpleMarkings = 0xff, //This setting means no char ,all information replaced by figure. show simple icon only.
};


/**
 手环的背景颜色
 
 - BKDeviceBGColorBlack: 黑色
 - BKDeviceBGColorWhite: 白色
 */
typedef NS_ENUM(NSUInteger, BKDeviceBGColor) {
    BKDeviceBGColorBlack = 0,
    BKDeviceBGColorWhite = 1,
};


/**
 温度单位
 
 - BKTemperatureUnitCentigrade: 摄氏温度
 - BKTemperatureUnitFahrenheit: 华氏温度
 */
typedef NS_ENUM(NSUInteger, BKTemperatureUnit) {
    BKTemperatureUnitCentigrade,
    BKTemperatureUnitFahrenheit,
};

