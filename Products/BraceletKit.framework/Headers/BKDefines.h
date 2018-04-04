//
//  BKDefines.h
//  BraceletKit
//
//  Created by xaoxuu on 27/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, BKDeviceClass) {
    BKDeviceClassNull       = 0,
    BKDeviceClassEggRoll    = 1,
    BKDeviceClassWatch      = 2,
    BKDeviceClassColorful   = 3,
    BKDeviceClassAny        = 8,
};

/**
 手环类型

 - BKDeviceTypeUnknown: 未知
 - BKDeviceTypeI5: I5
 - BKDeviceTypeV6: V6
 - BKDeviceTypeI7: I7
 - BKDeviceTypeI5PRO: I5PRO
 - BKDeviceTypeI6PRO: I6PRO
 - BKDeviceTypeR1: R1
 - BKDeviceTypeI6HR: I6HR
 - BKDeviceTypeI6NH: I6NH
 - BKDeviceTypeI6H9: I6H9
 - BKDeviceTypeWatchF1: GPS Watch
 */
typedef NS_ENUM(NSUInteger, BKDeviceType) {
    BKDeviceTypeUnknown = 0x00,
    BKDeviceTypeI5      = 0x01,
    BKDeviceTypeV6      = 0x02,
    BKDeviceTypeI7      = 0x03,
    BKDeviceTypeI5PRO   = 0x04,
    BKDeviceTypeI6PRO   = 0x05,
    BKDeviceTypeR1      = 0x06,
    BKDeviceTypeI6HR    = 0x13,
    BKDeviceTypeI6NH    = 0x15,
    BKDeviceTypeI6H9    = 0x16,
    BKDeviceTypeWatchF1 = 0X17,
};


/**
 连接状态

 - BKConnectStateUnknown: 未知
 - BKConnectStateUnbinding: 未绑定
 - BKConnectStateBindingUnconnected: 已绑定但未连接
 - BKConnectStateConnected: 已绑定已连接
 */
typedef NS_ENUM(NSUInteger, BKConnectState) {
    BKConnectStateUnknown,
    BKConnectStateUnbinding,
    BKConnectStateBindingUnconnected,
    BKConnectStateConnected,
};

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
 查询单位(查询)
 
 - BKQueryUnitDaily: 每日数据。在查询结果中，一个query对象代表一天
 - BKQueryUnitWeekly: 每周数据。在查询结果中，一个query对象代表一周
 - BKQueryUnitMonthly: 每月数据。在查询结果中，一个query对象代表一月
 - BKQueryUnitYearly: 每年数据。在查询结果中，一个query对象代表一年
 */
typedef NS_ENUM(NSUInteger, BKQuerySelectionUnit) {
    BKQuerySelectionUnitDaily,
    BKQuerySelectionUnitWeekly,
    BKQuerySelectionUnitMonthly,
    BKQuerySelectionUnitYearly
};

/**
 查询单位（视图）
 
 - BKQueryViewUnitDaily: 每日数据视图
 - BKQueryViewUnitWeekly: 周度视图
 - BKQueryViewUnitMonthly: 月度视图
 - BKQueryViewUnitYearly: 年度视图
 */
typedef NS_ENUM(NSUInteger, BKQueryViewUnit) {
    BKQueryViewUnitDaily   = 1,
    BKQueryViewUnitWeekly  = 7,
    BKQueryViewUnitMonthly = 31,
    BKQueryViewUnitYearly  = 365,
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
 - BKTemperatureUnitKelvin:     开尔文温度
 */
typedef NS_ENUM(NSUInteger, BKTemperatureUnit) {
    BKTemperatureUnitCentigrade,
    BKTemperatureUnitFahrenheit,
    BKTemperatureUnitKelvin,
};


typedef NS_ENUM(NSInteger,BKWeatherCondition) {
    BKWeatherConditionFine = 0,            //晴
    BKWeatherConditionCloudy = 1,          //多云
    BKWeatherConditionOvercast = 2,        //阴天
    BKWeatherConditionLightRain = 3,       //小雨
    BKWeatherConditionModerateRain = 4,    //中雨
    BKWeatherConditionHeavyRain = 5,       //大雨
    BKWeatherConditionShower = 6,          //阵雨
    BKWeatherConditionSnow = 7,            //雪
    BKWeatherConditionHaze = 8,            //雾霾
    BKWeatherConditionSandstorm = 9,        //沙尘暴
    BKWeatherConditionNotContain = 10,
};



typedef NS_ENUM (NSInteger,BKDNDType){
    BKDNDTypeNull = 0 , // mean closed dndMode
    BKDNDTypeNormal ,
    BKDNDTypeSleep ,   //  firmware must be supportted if used
    BKDNDTypeAllDay,   //  firmware must be supportted if used
};

/**
 高3位是铃声 0~7对应不同铃声
 低5位是反复次数 默认0x01
 High 3 is the ringtone 0 ~ 7 corresponds to different ringtones
 Low 5 is the number of iterations default 0x01
 */
typedef NSInteger BKRingId;
