//
//  BKServices.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKUser.h"
#import "BKScanner.h"
#import "BKConnector.h"


@class BKServices;

@protocol BKServicesDelegate <NSObject>
@optional
/**
 服务加载完毕

 @param services 服务
 */
- (void)servicesDidLoadFinished:(BKServices *)services;

@end

@interface BKServices : NSObject <BKDataObserver>

/**
 用户
 */
@property (strong, readonly, nonatomic) BKUser *user;


/**
 扫描器
 */
@property (strong, readonly, nonatomic) BKScanner *scanner;


/**
 连接器
 */
@property (strong, readonly, nonatomic) BKConnector *connector;




+ (instancetype)sharedInstance;


/**
 注册服务

 @param user 用户
 */
- (BOOL)registerServiceWithUser:(BKUser *)user;


/**
 注册服务代理
 
 @param delegate 代理
 */
- (void)registerServicesDelegate:(NSObject<BKServicesDelegate> *)delegate;

/**
 取消注册服务代理
 
 @param delegate 代理
 */
- (void)unRegisterServicesDelegate:(NSObject<BKServicesDelegate> *)delegate;

/**
 注册扫描代理
 
 @param delegate 代理
 */
- (void)registerScanDelegate:(NSObject<BKScanDelegate> *)delegate;

/**
 取消注册扫描代理
 
 @param delegate 代理
 */
- (void)unRegisterScanDelegate:(NSObject<BKScanDelegate> *)delegate;


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
 注册设备代理

 @param delegate 代理
 */
- (void)registerDeviceDelegate:(NSObject<BKDeviceDelegate> *)delegate;

/**
 取消注册设备代理

 @param delegate 代理
 */
- (void)unRegisterDeviceDelegate:(NSObject<BKDeviceDelegate> *)delegate;


/**
 注册数据代理
 
 @param observer 代理
 */
- (void)registerDataObserver:(NSObject<BKDataObserver> *)observer;

/**
 取消注册数据代理
 
 @param observer 代理
 */
- (void)unRegisterDataObserver:(NSObject<BKDataObserver> *)observer;


@end
