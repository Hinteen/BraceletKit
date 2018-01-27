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
- (void)connectorDidUnconnectedDevice:(BKDevice *)device;

/**
 与设备连接失败
 
 @param device 设备
 */
- (void)connectorDidFailToConnectDevice:(BKDevice *)device;

/**
 连接超时
 */
- (void)connectorDidConnectTimeout;

@end

@interface BKConnector : NSObject


/**
 代理
 */
@property (weak, nonatomic) NSObject<BKConnectDelegate> *delegate;

/**
 设备
 */
@property (strong, readonly, nonatomic) BKDevice *device;


/**
 初始化连接
 
 @param delegate 代理
 @return 连接实例
 */
- (instancetype)initWithDelegate:(NSObject<BKConnectDelegate> *)delegate;

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
