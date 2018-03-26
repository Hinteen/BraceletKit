//
//  BKConnector.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKDevice.h"


@protocol BKConnectDelegate <NSObject>

@optional

/**
 已连接设备
 
 @param device 设备
 */
- (void)connectorDidConnectedDevice:(BKDevice *)device;

/**
 已断开设备
 
 @param device 设备
 */
- (void)connectorDidUnconnectedDevice:(BKDevice *)device error:(NSError *)error;

/**
 与设备连接失败
 
 @param device 设备
 */
- (void)connectorDidFailToConnectDevice:(BKDevice *)device error:(NSError *)error;

/**
 连接超时
 */
- (void)connectorDidConnectTimeout;

@end

@class CBCentralManager, CBPeripheral;
@interface BKConnector : NSObject

/**
 设备
 */
@property (strong, readonly, nonatomic) BKDevice *device;
/**
 连接状态
 */
@property (assign, readonly, nonatomic) BKConnectState state;

/**
 中心设备管理器
 */
@property (strong, readonly, nonatomic) CBCentralManager *central;

/**
 外设
 */
@property (strong, readonly, nonatomic) CBPeripheral *peripheral;

/**
 注册连接代理
 
 @param delegate 代理
 */
- (void)registerConnectDelegate:(NSObject<BKConnectDelegate> *)delegate;

/**
 取消注册连接代理
 
 @param delegate 代理
 */
- (void)unRegisterConnectDelegate:(NSObject<BKConnectDelegate> *)delegate;

/**
 连接设备
 
 @param device 设备
 */
- (void)connectDevice:(BKDevice *)device;


/**
 恢复离线设备
 用于数据调试，以这台设备的身份查看数据以及app展示效果

 @param device 离线设备
 */
- (void)restoreOfflineDevice:(BKDevice *)device;

/**
 断开连接
 */
- (void)disConnectDevice;


@end
