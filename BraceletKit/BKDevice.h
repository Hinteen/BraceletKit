//
//  BKDevice.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

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


@interface BKDevice : RLMObject

/**
 mac
 */
@property (copy, nonatomic) NSString *mac;
/**
 name
 */
@property (copy, nonatomic) NSString *name;
/**
 uuid
 */
@property (copy, nonatomic) NSString *uuid;
/**
 model
 */
@property (copy, nonatomic) NSString *model;
/**
 version
 */
@property (copy, nonatomic) NSString *version;

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

@end
RLM_ARRAY_TYPE(BKDevice)

@interface BKDevice (BKCachedExtension)


+ (CGFloat)readCachedBatteryPercent;
   
@end

