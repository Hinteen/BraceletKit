//
//  BKDescriptionUtilities.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 02/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDescriptionUtilities.h"

static NSDictionary *languageDescriptions(){
    static NSDictionary *dict;
    if (!dict) {
        dict = @{NSStringFromNSInteger(BKLanguageDefault):@"英语",
                 NSStringFromNSInteger(BKLanguageSimpleChinese):@"简体中文",
                 NSStringFromNSInteger(BKLanguageItalian):@"意大利语",
                 NSStringFromNSInteger(BKLanguageJapanese):@"日语",
                 NSStringFromNSInteger(BKLanguageFrench):@"法语",
                 NSStringFromNSInteger(BKLanguageGerman):@"德语",
                 NSStringFromNSInteger(BKLanguagePortugal):@"葡萄牙语",
                 NSStringFromNSInteger(BKLanguageSpanish):@"西班牙语",
                 NSStringFromNSInteger(BKLanguageRussian):@"俄罗斯语",
                 NSStringFromNSInteger(BKLanguageKorean):@"韩语",
                 NSStringFromNSInteger(BKLanguageArabic):@"阿拉伯语",
                 NSStringFromNSInteger(BKLanguageVietnamese):@"越南语",
                 NSStringFromNSInteger(BKLanguageSimpleMarkings):@"仅显示图标",
                 };
    }
    return dict;
}

static NSDictionary *tempUnitDescriptions(){
    static NSDictionary *dict;
    if (!dict) {
        dict = @{NSStringFromNSInteger(BKTemperatureUnitCentigrade):@"℃ 摄氏度",
                 NSStringFromNSInteger(BKTemperatureUnitFahrenheit):@"℉ 华氏度",
                 };
    }
    return dict;
}

static NSDictionary *distanceUnitDescriptions(){
    static NSDictionary *dict;
    if (!dict) {
        dict = @{NSStringFromNSInteger(BKDistanceUnitMetric):@"公制",
                 NSStringFromNSInteger(BKDistanceUnitImperial):@"英制",
                 };
    }
    return dict;
}


static NSDictionary *hourFormatDescriptions(){
    static NSDictionary *dict;
    if (!dict) {
        dict = @{NSStringFromNSInteger(BKHourFormat12):@"12小时制",
                 NSStringFromNSInteger(BKHourFormat24):@"24小时制",
                 };
    }
    return dict;
}


static NSDictionary *dateFormatDescriptions(){
    static NSDictionary *dict;
    if (!dict) {
        dict = @{NSStringFromNSInteger(BKDateFormatMMDD):@"月月/日日",
                 NSStringFromNSInteger(BKDateFormatDDMM):@"日日/月月",
                 };
    }
    return dict;
}


static NSDictionary *bgColorDescriptions(){
    static NSDictionary *dict;
    if (!dict) {
        dict = @{NSStringFromNSInteger(BKDeviceBGColorBlack):@"黑色",
                 NSStringFromNSInteger(BKDeviceBGColorWhite):@"白色",
                 };
    }
    return dict;
}



@implementation BKDescriptionUtilities

+ (NSString *)languageDescription:(BKLanguage)language{
    return languageDescriptions()[NSStringFromNSInteger(language)];
}

+ (BKLanguage)languageWithDescription:(NSString *)description{
    NSArray *allKeys = languageDescriptions().allKeys;
    for (NSString *tmp in allKeys) {
        if ([languageDescriptions()[tmp] isEqualToString:description]) {
            return (BKLanguage)tmp.integerValue;
        }
    }
    return BKLanguageDefault;
}


+ (NSString *)tempUnitDescription:(BKTemperatureUnit)temp{
    return tempUnitDescriptions()[NSStringFromNSInteger(temp)];
}

+ (BKTemperatureUnit)tempWithDescription:(NSString *)description{
    NSArray *allKeys = tempUnitDescriptions().allKeys;
    for (NSString *tmp in allKeys) {
        if ([tempUnitDescriptions()[tmp] isEqualToString:description]) {
            return (BKTemperatureUnit)tmp.integerValue;
        }
    }
    return BKTemperatureUnitCentigrade;
}




+ (NSString *)distanceUnitDescription:(BKDistanceUnit)distance{
    return distanceUnitDescriptions()[NSStringFromNSInteger(distance)];
}

+ (BKDistanceUnit)distanceWithDescription:(NSString *)description{
    NSArray *allKeys = distanceUnitDescriptions().allKeys;
    for (NSString *tmp in allKeys) {
        if ([distanceUnitDescriptions()[tmp] isEqualToString:description]) {
            return (BKDistanceUnit)tmp.integerValue;
        }
    }
    return BKDistanceUnitMetric;
}




+ (NSString *)hourFormatDescription:(BKHourFormat)hour{
    return hourFormatDescriptions()[NSStringFromNSInteger(hour)];
}

+ (BKHourFormat)hourFormatWithDescription:(NSString *)description{
    NSArray *allKeys = hourFormatDescriptions().allKeys;
    for (NSString *tmp in allKeys) {
        if ([hourFormatDescriptions()[tmp] isEqualToString:description]) {
            return (BKHourFormat)tmp.integerValue;
        }
    }
    return BKHourFormat24;
}



+ (NSString *)dateFormatDescription:(BKDateFormat)date{
    return dateFormatDescriptions()[NSStringFromNSInteger(date)];
}

+ (BKDateFormat)dateFormatWithDescription:(NSString *)description{
    NSArray *allKeys = dateFormatDescriptions().allKeys;
    for (NSString *tmp in allKeys) {
        if ([dateFormatDescriptions()[tmp] isEqualToString:description]) {
            return (BKDateFormat)tmp.integerValue;
        }
    }
    return BKDateFormatMMDD;
}



+ (NSString *)bgColorDescription:(BKDeviceBGColor)date{
    return bgColorDescriptions()[NSStringFromNSInteger(date)];
}

+ (BKDeviceBGColor)bgColorWithDescription:(NSString *)description{
    NSArray *allKeys = bgColorDescriptions().allKeys;
    for (NSString *tmp in allKeys) {
        if ([bgColorDescriptions()[tmp] isEqualToString:description]) {
            return (BKDeviceBGColor)tmp.integerValue;
        }
    }
    return BKDeviceBGColorBlack;
}




@end
