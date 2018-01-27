//
//  BKDevice.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"
#import "BKDefines.h"

@class CBPeripheral, ZeronerBlePeripheral, BKPreferences;
NS_ASSUME_NONNULL_BEGIN
@protocol BKDeviceDelegate <NSObject>

@optional
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

#pragma mark - db

+ (instancetype)lastConnectedDevice;

- (NSString *)restoreMac;


#pragma mark - function


/**
 立即同步时间
 
 @param completion 操作成功
 @param error 操作失败及其原因
 */
- (void)syncTimeAtOnceCompletion:(void(^)(void))completion error:(void (^)(NSError *error))error;
/**
 进入或退出拍照模式

 @param cameraMode 进入或退出
 @param completion 操作成功
 @param error 操作失败及其原因
 */
- (void)cameraMode:(BOOL)cameraMode completion:(void(^)(void))completion error:(void (^)(NSError *error))error;

/**
 向手环推送消息（不要超过手环一屏内容，否则显示不全）

 @param message 消息内容
 @param completion 操作成功
 @param error 操作失败及其原因
 */
- (void)pushMessage:(NSString *)message completion:(void(^)(void))completion error:(void (^)(NSError *error))error;

@end
NS_ASSUME_NONNULL_END
