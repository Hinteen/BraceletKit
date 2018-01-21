//
//  BKDevice.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKBaseTable.h"
#import <BLE3Framework/BLE3Framework.h>

@class CBPeripheral, ZeronerBlePeripheral;

@protocol BKDeviceDelegate <NSObject>

- (void)didUpdateDeviceInfo;

- (void)didUpdateDeviceBatteryLevel:(CGFloat)batteryLevel;

/**
 手环点击了拍照
 */
- (void)didTappedTakePicture;
/**
 手环点击了查找手机
 */
- (void)didTappedFindMyPhone;

@end


@interface BKDevice : BKBaseTable

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
 delegate
 */
@property (weak, nonatomic) NSObject<BKDeviceDelegate> *delegate;

+ (instancetype)currentDevice;


@end


@interface BKDevice (BKCachedExtension)


+ (CGFloat)readCachedBatteryPercent;
   
@end

