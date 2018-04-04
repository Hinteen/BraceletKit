//
//  BKPreferences.h
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"
#import "BKDefines.h"

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
 找手机功能的开关 和 自动运动识别 （同一个字段，不同协议固件支持内容不同，findPhoneSwitch仅少量固件支持）
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
@property (assign, nonatomic) BOOL disconnectTip;
/**
 找手机功能的开关
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


- (void)transaction:(void (^)(BKPreferences *preferences))transaction;

- (BOOL)saveToDatabaseIfNotExists;

@end

