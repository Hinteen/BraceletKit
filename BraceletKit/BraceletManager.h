//
//  BraceletManager.h
//  BraceletKit
//
//  Created by xaoxuu on 25/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BLE3Framework/BLE3Framework.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BraceletManager
@optional

- (void)braceletDidDiscoverDeviceWithMAC:(ZeronerBlePeripheral *)iwDevice;

- (void)braceletDidUpdateDeviceInfo:(ZeronerDeviceInfo *)deviceInfo;

- (void)braceletDidUpdateDeviceBattery:(ZeronerDeviceInfo *)deviceInfo;


- (void)braceletDidTakePicture;

@end

@interface BraceletManager : NSObject <BleDiscoverDelegate, BleConnectDelegate, BLELib3Delegate>

// @xaoxuu: BLELib3
@property (strong, nonatomic) BLELib3 *bleSDK;

// @xaoxuu: delegates
@property (strong, nonatomic) NSMutableArray *delegates;

@property (strong, readonly, nonatomic) ZeronerDeviceInfo *currentDeviceInfo;

// @xaoxuu: camera mode
@property (assign, nonatomic) BOOL cameraMode;

- (NSMutableArray<ZeronerBlePeripheral *> *)bindDevices;


+ (instancetype)defaultManager;

+ (instancetype)sharedInstance;

- (void)scanDevice;

- (void)connectDevice:(ZeronerBlePeripheral *)device;

- (void)disConnectDevice;










/**
 注册代理
 
 @param delegate 代理
 */
- (void)registerDelegate:(NSObject<BraceletManager> *)delegate;

/**
 取消注册代理
 
 @param delegate 代理
 */
- (void)unRegisterDelegate:(NSObject<BraceletManager> *)delegate;





@end
NS_ASSUME_NONNULL_END
