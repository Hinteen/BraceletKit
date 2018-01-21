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

- (void)bkDiscoverDevice:(BKDevice *)device;

- (void)bkConnectedDevice:(BKDevice *)device;

- (void)bkUnconnectedDevice:(BKDevice *)device;

- (void)bkFailToConnectDevice:(BKDevice *)device;

- (void)bkConnectTimeout;

@end

@interface BKConnect : NSObject

/**
 delegate
 */
@property (weak, nonatomic) NSObject<BKConnectDelegate> *delegate;
/**
 current device
 */
@property (strong, readonly, nonatomic) BKDevice *device;

+ (instancetype)currentConnect;

- (instancetype)initWithDelegate:(NSObject<BKConnectDelegate> *)delegate;

- (void)scanDevice;

- (void)stopScan;

- (void)connectDevice:(BKDevice *)device;

- (void)disConnectDevice;

@end


