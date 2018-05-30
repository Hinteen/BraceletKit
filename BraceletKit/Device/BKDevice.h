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
//@property (weak, nonatomic) NSObject<BKSessionDelegate> *delegate;

+ (instancetype)currentDevice;


@end
NS_ASSUME_NONNULL_END
