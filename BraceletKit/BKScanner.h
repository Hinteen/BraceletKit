//
//  BKScanner.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKDevice, CBCentralManager;
@protocol BKScanDelegate <NSObject>

@optional

/**
 SDK发现设备
 
 @param device 设备
 */
- (void)scannerDidDiscoverDevice:(BKDevice *)device;

/**
 CentralManager状态改变

 @param central CentralManager
 */
- (void)scannerForCentralManagerDidUpdateState:(CBCentralManager *)central;

/**
 CentralManager发现设备
 
 @param device 设备
 */
- (void)scannerForCentralManagerDidDiscoverDevice:(BKDevice *)device;

@end


@interface BKScanner : NSObject


/**
 代理
 */
@property (weak, nonatomic) NSObject<BKScanDelegate> *delegate;


- (instancetype)initWithDelegate:(NSObject<BKScanDelegate> *)delegate;

/**
 扫描设备
 */
- (void)scanDevice;

/**
 停止扫描
 */
- (void)stopScan;


@end
