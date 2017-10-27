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

@end

@interface BraceletManager : NSObject <BleDiscoverDelegate, BleConnectDelegate, BLELib3Delegate>

// @xaoxuu: BLELib3
@property (strong, nonatomic) BLELib3 *bleSDK;

// @xaoxuu: delegates
@property (strong, nonatomic) NSMutableArray *delegates;

+ (instancetype)defaultManager;

+ (instancetype)sharedInstance;

- (void)scanDevice;

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





- (void)scan;


@end
NS_ASSUME_NONNULL_END
