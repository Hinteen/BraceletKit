//
//  BKConnector.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKConnector.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "_BKModelHelper.h"
#import "BKServices.h"

@interface BKConnector() <CBCentralManagerDelegate, BleConnectDelegate>

@property (strong, nonatomic) CBCentralManager *central;

@property (strong, nonatomic) CBPeripheral *peripheral;

@end

@interface BKDevice() <BLELib3Delegate>

@end

@implementation BKConnector


- (instancetype)init{
    if (self = [super init]) {
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        [BLELib3 shareInstance].connectDelegate = self;
    }
    return self;
}


- (instancetype)initWithDelegate:(NSObject<BKConnectDelegate> *)delegate;{
    if (self = [self init]) {
        _delegate = delegate;
    }
    return self;
}


- (void)connectDevice:(BKDevice *)device{
    [[BLELib3 shareInstance] connectDevice:device.zeronerBlePeripheral];
    AXCachedLogOBJ(@"调用了连接方法");
}

- (void)disConnectDevice{
    [[BLELib3 shareInstance] unConnectDevice];
    [[BLELib3 shareInstance] debindFromSystem];
    AXCachedLogOBJ(@"调用了断开连接方法");
}


#pragma mark - system cb delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}



#pragma mark - connect delegate

#pragma mark required
/**
 *  invoked when the device did connected by the centeral
 *
 *  @param device the device did connected
 */
- (void)IWBLEDidConnectDevice:(ZeronerBlePeripheral *)device{
    AXCachedLogOBJ(device);
    self.peripheral = device.cbDevice;
    _device = device.transformToBKDevice;
    [BLELib3 shareInstance].delegate = self.device;
    [self.central connectPeripheral:self.peripheral options:nil];
    if ([self.delegate respondsToSelector:@selector(connectorDidConnectedDevice:)]) {
        [self.delegate connectorDidConnectedDevice:device.transformToBKDevice];
    }
}

#pragma mark optional
/**
 *   @see BLEParamSign
 *   设置蓝牙参数，默认 BLEParamSignConnect
 */
- (BLEParamSign)bleParamSignSetting{
    AXCachedLogOBJ(@"设置蓝牙参数，默认 BLEParamSignConnect");
    return BLEParamSignConnect;
}


/**
 *  invoked when the device did disConnect with the connectted centeral
 *
 *  @param device the device whom the centeral was connected
 */
- (void)IWBLEDidDisConnectWithDevice:(ZeronerBlePeripheral *)device andError:(NSError *)error{
    AXCachedLogOBJ(device);
    AXCachedLogError(error);
    _device = nil;
    if (self.peripheral) {
        [self.central cancelPeripheralConnection:self.peripheral];
    }
    if ([self.delegate respondsToSelector:@selector(connectorDidUnconnectedDevice:)]) {
        [self.delegate connectorDidUnconnectedDevice:device.transformToBKDevice];
    }
}

/**
 *  invoked when the device did fail to connected by the centeral
 *
 *  @param device the device whom the centeral want to be connected
 */
- (void)IWBLEDidFailToConnectDevice:(ZeronerBlePeripheral *)device andError:(NSError *)error{
    AXCachedLogOBJ(device);
    AXCachedLogError(error);
    if ([self.delegate respondsToSelector:@selector(connectorDidFailToConnectDevice:)]) {
        [self.delegate connectorDidFailToConnectDevice:device.transformToBKDevice];
    }
}

/**
 *  invoked when connect more than 10 second.
 */
- (void)IWBLEConnectTimeOut{
    AXCachedLogError(@"连接超时");
    if ([self.delegate respondsToSelector:@selector(connectorDidConnectTimeout)]) {
        [self.delegate connectorDidConnectTimeout];
    }
}

/**
 *  表示手环注册ANCS失败，此时消息推送不能work，需要重新配对。
 *  This method would be invoked when the Peripheral disConnected with the system; In this case ,your app should tell the user who could ingore the device on system bluetooth ,and reconnect and pair the device. or there will be risk of receiving a message reminder.
 *
 *  @param deviceName the Device Name
 */
- (void)deviceDidDisConnectedWithSystem:(NSString *)deviceName{
    AXCachedLogOBJ(deviceName);
    AXCachedLogError(@"手环注册ANCS失败，此时消息推送不能work，需要重新配对。");
}

/**
 *  this method would be invoked when the app connected a device who is supportted by protocol2_0
 *  当前手环是2.0协议的手环是调用这个方法。
 */
- (void)didConnectProtocolNum2_0{
    AXCachedLogOBJ(@"当前手环是2.0协议的手环");
}

/**
 *  Bluetooth state changed.
 *  检测到蓝牙状态变化
 */
- (void)centralManagerStatePoweredOff{
    AXCachedLogOBJ(@"蓝牙关");
    
}
- (void)centralManagerStatePoweredOn{
    AXCachedLogOBJ(@"蓝牙开");
    
}



@end
