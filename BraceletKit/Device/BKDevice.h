//
//  BKDevice.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"


@class CBPeripheral, ZeronerBlePeripheral, BKPreferences;

@protocol BKDeviceDelegate <NSObject>

/**
 更新了设备信息
 */
- (void)deviceDidUpdateInfo;

/**
 更新了电池信息

 @param batteryPercent 电池百分比
 */
- (void)deviceDidUpdateBatteryPercent:(CGFloat)batteryPercent;

/**
 手环点击了拍照
 */
- (void)deviceDidTappedTakePicture;

/**
 手环点击了查找手机
 */
- (void)deviceDidTappedFindMyPhone;

@end


@interface BKDevice : BKData <BKData>

/**
 mac
 */
@property (copy, nonatomic) NSString *mac;
/**
 uuid
 */
@property (copy, nonatomic) NSString *uuid;
/**
 name
 */
@property (copy, nonatomic) NSString *name;
/**
 model
 */
@property (copy, nonatomic) NSString *model;
/**
 version
 */
@property (copy, nonatomic) NSString *version;
/**
 battery percent
 */
@property (assign, nonatomic) CGFloat battery;
/**
 peripheral
 */
@property (strong, nonatomic) CBPeripheral *peripheral;
/**
 rssi
 */
@property (strong, nonatomic) NSNumber *rssi;
/**
 zer
 */
@property (strong, nonatomic) ZeronerBlePeripheral *zeronerBlePeripheral;

/**
 setting
 */
@property (strong, nonatomic) BKPreferences *preferences;


/**
 delegate
 */
@property (weak, nonatomic) NSObject<BKDeviceDelegate> *delegate;

+ (instancetype)currentDevice;

+ (instancetype)lastConnectedDevice;

- (NSString *)restoreMac;



@end



