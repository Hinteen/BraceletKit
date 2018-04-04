//
//  BKSession.h
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class BKScanner, BKConnector, BKDeviceManager, BKDevice, BKUser, BKPreferences, BKWeather;
@class BKDNDMode, BKAlarmClock, BKSedentary, BKSchedule,BKSportTarget, BKMotor, BKRoll, BKSummaryData;
@protocol BKSessionDelegate <NSObject>

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
//- (void)deviceDidUpdateData:(__kindof BKData *)data;

/**
Receive general data from the watch (Date that will be used for the more specific reauest)
 */
- (void) deviceDidUpdateNormalHealthDataInf:(NSDate *)zrDInfo;


- (void) deviceDidUpdateSummaryData:(BKSummaryData *)summaryData;

@end


@interface BKSession : NSObject

/**
 device class
 */
@property (assign, nonatomic) BKDeviceClass deviceClass;



/**
 scanner
 */
@property (strong, nonatomic) BKScanner *scanner;

/**
 connector
 */
@property (strong, nonatomic) BKConnector *connector;

+ (instancetype)sharedInstance;

- (void)registerDelegate:(NSObject<BKSessionDelegate> *)delegate;

- (void)unRegisterDelegate:(NSObject<BKSessionDelegate> *)delegate;

+ (instancetype)requestWithDeviceClass:(BKDeviceClass)deviceClass;

- (void)requestScanDevice:(BOOL)scan completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error;

- (void)requestBindDevice:(BKDevice *)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error;

- (void)requestUnbindDevice:(nullable BKDevice *)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error;


/**
 请求同步用户数据
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateUser:(BKUser *)user completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nonnull error))error;


/**
 请求更新偏好设置
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdatePreferences:(BKPreferences *)preferences completion:(void (^)(void))completion error:(void (^)(NSError * _Nonnull))error;

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
- (void)requestFindPhoneMode:(BOOL)findPhoneMode completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error;


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

- (void) requestUpdateSpecialDataCompletion:(NSDate *)date completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

/**
 请求立即停止更新所有健康数据
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestStopUpdateAllHealthDataCompletion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;


/**
 请求更新天气信息
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestReadDeviceInfo:(BKDevice *)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestReadDeviceBattery:(BKDevice *)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestReadSportTargets:(BKSportTarget *)sportTarget completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestReadSedentary:(BKSedentary *)sedentary completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestReadSpecialList:(NSInteger)rId completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestReadAllList:(BKRoll *)roll completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;




- (void)requestUpdateWeatherInfo:(void (^)(BKWeather *weather))weatherInfo completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateDNDMode:(void (^)(BKDNDMode *dnd))dndMode completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateAlarmClock:(BKAlarmClock *)alarmClock completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateSedentary:(BKSedentary *)sedentary completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateSchedule:(BKSchedule *)schedule completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateMotor:(BKMotor *)motor completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateSportTarget:(BKSportTarget *)sportTarget completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateSpecialList:(NSArray <BKRoll *>*)rolls completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;





- (void)requestClearAllClocks:(BKSchedule *)schedule completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestClearAllSchedule:(BKSchedule *)schedule completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestRemoveSpecialList:(NSArray <BKRoll *>*)rolls completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestClearAllLists:(BKRoll *)roll completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;


- (void)requestFeelMotor:(BKMotor *)motor completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

@end
NS_ASSUME_NONNULL_END
