//
//  BKPreferences.h
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"

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

@interface BKPreferences : BKData <BKData>


/**
 手环使用的语言设置开关，默认设置受系统语言影响，未作适配的系统语言情况下为braceletLanguageDefault。
 */
@property (assign, nonatomic) BKLanguage language;
/**
 公英制单位切换开关 ，默认是公制。
 */
@property (assign, nonatomic) BKDistanceUnit distanceUnit;
/**
 温度单位
 */
@property (assign, nonatomic) BKTemperatureUnit temperatureUnit;
/**
 手环显示的日期格式，0表示 月月／日日 ，1表示 日日／月月.默认是0
 */
@property (assign, nonatomic) BKDateFormat dateFormat;
/**
 时间制式切换开关 ,默认是24小时制。
 */
@property (assign, nonatomic) BKHourFormat hourFormat;


/**
 找手机功能的开关 ,自动运动识别 （同一个字段，不同协议固件支持内容不同，findPhoneSwitch仅少量固件支持）
 */
@property (assign, nonatomic) BOOL autoSport;
/**
 自动监测心率开关 ,关闭自动心率后非运动状态时不检测心率，默认为YES,。
 */
@property (assign, nonatomic) BOOL autoHeartRate;
/**
 自动睡眠开关, 默认为YES, 也就是手环自动识别睡眠状态。
 */
@property (assign, nonatomic) BOOL autoSleep;



/**
 断连提醒，默认为NO,也就是关闭提醒。
 */
@property (assign, nonatomic) BOOL disConnectTip;
/**
 findPhoneSwitch
 */
@property (assign, nonatomic) BOOL findPhoneSwitch;
/**
 ledSwitch
 * switch of led light ,default is NO ,brcelet i7 is not supported .
 * LED灯开关，默认为NO，i7手环不支持。
 */
@property (assign, nonatomic) BOOL ledSwitch;
/**
 leftHand
 惯用手 默认@YES，右手
 */
@property (assign, nonatomic) BOOL leftHand;
/**
 advertisementSwitch
 */
@property (assign, nonatomic) BOOL advertisementSwitch;


/**
 屏幕背景颜色，默认为NO. YES为白色，NO为黑色.
 */
@property (assign, nonatomic) BKDeviceBGColor backgroundColor;
/**
 backlightStart
 */
@property (assign, nonatomic) NSUInteger backlightStart;
/**
 backlightEnd
 */
@property (assign, nonatomic) NSUInteger backlightEnd;

/**
 wristSwitch
 翻腕开关,默认为YES。
 */
@property (assign, nonatomic) BOOL wristSwitch;
/**
 仅在 wristSwitch 为YES的时候有效，在设置的时间间隔内，翻腕点亮屏幕功能可用。wristBlightStart和wristBlightEnd都设置为0时表示24小时有效。取值范围在0-23，表示每个整点。
 */
@property (assign, nonatomic) NSInteger wristBlightStart;
/**
 仅在 wristSwitch 为YES的时候有效，在设置的时间间隔内，翻腕点亮屏幕功能可用。wristBlightStart和wristBlightEnd都设置为0时表示24小时有效。取值范围在0-23，表示每个整点。
 */
@property (assign, nonatomic) NSInteger wristBlightEnd;



/**
 将当前的设置应用到设备
 */
- (void)applyToMyDevice;

- (BOOL)saveToDatabaseIfNotExists;

@end

