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

- (void)didDiscoverDevice:(BKDevice *)device;

- (void)didConnectedDevice:(BKDevice *)device;

- (void)didUnconnectedDevice:(BKDevice *)device;

- (void)didFailToConnectDevice:(BKDevice *)device;

- (void)didConnectTimeout;

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

- (instancetype)initWithDelegate:(NSObject<BKConnectDelegate> *)delegate;

- (void)scanDevice;

- (void)connectDevice:(BKDevice *)device;

- (void)disConnectDevice;

@end


