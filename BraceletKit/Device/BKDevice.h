//
//  BKDevice.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"
#import "BKDefines.h"
#import "BKWeather.h"

@class CBPeripheral, ZRBlePeripheral, BKPreferences, BKData;
NS_ASSUME_NONNULL_BEGIN
@protocol BKDeviceDelegate <NSObject>

@optional

/**
 设备是否正在同步

 @param synchronizing 正在同步
 */
- (void)deviceDidSynchronizing:(BOOL)synchronizing;

/**
 更新了同步进度

 @param progress 进度(0~1)
 */
- (void)deviceDidUpdateSynchronizeProgress:(CGFloat)progress;

/**
 更新了设备信息
 */
- (void)deviceDidUpdateInfo;

/**
 更新了电池信息

 @param battery 电池电量
 */
- (void)deviceDidUpdateBattery:(NSInteger)battery;

/**
 手环点击了拍照
 */
- (void)deviceDidTappedTakePicture;

/**
 手环点击了查找手机
 */
- (void)deviceDidTappedFindMyPhone;

/**
 更新了数据

 @param data 数据
 */
- (void)deviceDidUpdateData:(__kindof BKData *)data;

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
 type
 */
@property (assign, nonatomic) BKDeviceType type;
/**
 version
 */
@property (copy, nonatomic) NSString *version;
/**
 电池电量（0~100）
 */
@property (assign, nonatomic) NSInteger battery;

/**
 支持的语言
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *languages;

/**
 支持的功能
 */
@property (strong, nonatomic) NSMutableArray<NSNumber *> *functions;

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
@property (strong, nonatomic) ZRBlePeripheral *zrPeripheral;

/**
 setting
 */
@property (strong, nonatomic) BKPreferences *preferences;

/**
 是否正在同步
 */
@property (assign, nonatomic) BOOL isSynchronizing;

/**
 delegate
 */
@property (weak, nonatomic) NSObject<BKDeviceDelegate> *delegate;

+ (instancetype)currentDevice;



@end
NS_ASSUME_NONNULL_END
