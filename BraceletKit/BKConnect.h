//
//  BKConnect.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKDevice.h"


@protocol BKConnectDelegate <NSObject>

@optional;

/**
 发现设备

 @param device 设备
 */
- (void)bkDiscoverDevice:(BKDevice *)device;

/**
 已连接设备

 @param device 设备
 */
- (void)bkConnectedDevice:(BKDevice *)device;

/**
 已断开设备

 @param device 设备
 */
- (void)bkUnconnectedDevice:(BKDevice *)device;

/**
 与设备连接失败

 @param device 设备
 */
- (void)bkFailToConnectDevice:(BKDevice *)device;

/**
 连接超时
 */
- (void)bkConnectTimeout;

@end

@interface BKConnect : NSObject

/**
 代理
 */
@property (weak, nonatomic) NSObject<BKConnectDelegate> *delegate;
/**
 设备
 */
@property (strong, readonly, nonatomic) BKDevice *device;


/**
 当前的连接

 @return 连接实例
 */
+ (instancetype)currentConnect;

/**
 初始化连接

 @param delegate 代理
 @return 连接实例
 */
- (instancetype)initWithDelegate:(NSObject<BKConnectDelegate> *)delegate;

/**
 扫描设备
 */
- (void)scanDevice;

/**
 停止扫描
 */
- (void)stopScan;

/**
 连接设备

 @param device 设备
 */
- (void)connectDevice:(BKDevice *)device;

/**
 断开连接
 */
- (void)disConnectDevice;

@end


