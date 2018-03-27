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

@protocol BKSessionResponse <NSObject>



@end

@class BKScanner, BKConnector, BKDeviceManager, BKDevice, BKUser, BKPreferences, BKWeather;
@class BKDNDMode, BKAlarmClock, BKSedentary, BKSchedule;
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
- (void)requestUpdateWeatherInfo:(void (^)(BKWeather *weather))weatherInfo completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateDNDMode:(void (^)(BKDNDMode *dnd))dndMode completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestReadDeviceInfo:(BKDevice *)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestReadDeviceBattery:(BKDevice *)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;


- (void)requestUpdateAlarmClock:(BKAlarmClock *)alarmClock completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateSedentary:(BKSedentary *)sedentary completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestUpdateSchedule:(BKSchedule *)schedule completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;


- (void)requestClearAllClocks:(BKSchedule *)schedule completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;

- (void)requestClearAllSchedule:(BKSchedule *)schedule completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error;


@end
NS_ASSUME_NONNULL_END
