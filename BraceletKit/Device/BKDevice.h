//
//  BKDevice.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"
#import "BKDefines.h"

@class CBPeripheral, ZeronerBlePeripheral, BKPreferences, BKData;
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
@property (strong, nonatomic) ZeronerBlePeripheral *zeronerBlePeripheral;

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


#pragma mark - db

/**
 上一次连接过的设备

 @return 上一次连接过的设备
 */
+ (instancetype)lastConnectedDevice;

/**
 所有连接过的设备

 @return 所有连接过的设备
 */
+ (NSMutableArray<BKDevice *> *)allMyDevices;

/**
 恢复Mac地址

 @return Mac地址
 */
- (NSString *)restoreMac;



#pragma mark - function


/**
 请求同步用户数据
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateUserCompletion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nonnull error))error;

/**
 请求立即同步时间
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestSyncTimeAtOnceCompletion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error;

/**
 请求进入或退出拍照模式

 @param cameraMode 进入或退出
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestCameraMode:(BOOL)cameraMode completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error;

/**
 请求向手环推送消息（不要超过手环一屏内容，否则显示不全）

 @param message 消息内容
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestPushMessage:(NSString *)message completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error;

/**
 请求更新电池电量信息

 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateBatteryCompletion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

/**
 请求更新所有健康数据

 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateAllHealthDataCompletion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

/**
 请求立即停止更新所有健康数据
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestStopUpdateAllHealthDataCompletion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

@end
NS_ASSUME_NONNULL_END
