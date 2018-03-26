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
#import "BKSession.h"

@interface BKConnector() <CBCentralManagerDelegate, BleConnectDelegate, BKServicesDelegate>

@property (strong, nonatomic) NSMutableArray<NSObject<BKConnectDelegate> *> *connectDelegates;

@end

@interface BKDevice() <BKConnectDelegate, BKDataObserver, BLEquinox>

@end

@implementation BKConnector


- (instancetype)init{
    if (self = [super init]) {
        _state = BKConnectStateUnknown;
        _central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//        [BLELib3 shareInstance].connectDelegate = self;
        [[BLEAutumn midAutumn:BLEProtocol_Any] registerSolsticeEquinox:self];
        self.connectDelegates = [NSMutableArray array];
    }
    return self;
}


- (void)registerConnectDelegate:(NSObject<BKConnectDelegate> *)delegate{
    if (delegate && ![self.connectDelegates containsObject:delegate]) {
        [self.connectDelegates addObject:delegate];
    }
}

- (void)unRegisterConnectDelegate:(NSObject<BKConnectDelegate> *)delegate{
    if (delegate && [self.connectDelegates containsObject:delegate]) {
        [self.connectDelegates removeObject:delegate];
    }
}

- (void)allConnectDelegates:(void (^)(NSObject<BKConnectDelegate> *delegate))handler{
    [self.connectDelegates enumerateObjectsUsingBlock:^(NSObject<BKConnectDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}

- (void)servicesDidLoadFinished:(BKServices *)service{
//    _device = [BKDevice lastConnectedDevice];
}

- (void)connectDevice:(BKDevice *)device{
    AXCachedLogOBJ(@"调用了连接方法");
    [[BKSession sharedInstance] requestBindDevice:device completion:^{
        AXCachedLogOBJ(@"设备绑定成功");
    } error:^(NSError * _Nullable error) {
        AXCachedLogError(error);
    }];
}

- (void)restoreOfflineDevice:(BKDevice *)device{
    AXCachedLogOBJ(@"调用了恢复离线设备的方法");
    _state = BKConnectStateBindingUnconnected;
    _device = device;
//    [[BKServices sharedInstance] registerConnectDelegate:device];
    
    if (self.central.state == CBCentralManagerStatePoweredOn) {
        [[BKServices sharedInstance].scanner scanDevice];
    }
    
}

- (void)disConnectDevice{
    if (self.state == BKConnectStateConnected) {
        AXCachedLogOBJ(@"调用了断开连接方法");
        [[BKSession sharedInstance] requestUnbindDevice:nil completion:^{
            AXCachedLogOBJ(@"解绑成功");
        } error:^(NSError * _Nullable error) {
            AXCachedLogError(error);
        }];
    } else {
        AXCachedLogOBJ(@"尝试断开连接，但当前已经是离线模式");
        // 如果是离线模式，断开的动作实际上只是remove当前的离线设备
//        [[BKServices sharedInstance] unRegisterConnectDelegate:self.device];
        _device = nil;
    }
}



#pragma mark - system cb delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}



#pragma mark - connect delegate

/**
 已连接设备
 
 @param device 设备
 */
- (void)connectorDidConnectedDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidConnectedDevice:)]) {
            [delegate connectorDidConnectedDevice:device];
        }
    }];
}

/**
 已断开设备
 
 @param device 设备
 */
- (void)connectorDidUnconnectedDevice:(BKDevice *)device error:(NSError *)error{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidUnconnectedDevice:error:)]) {
            [delegate connectorDidUnconnectedDevice:device error:error];
        }
    }];
}

/**
 与设备连接失败
 
 @param device 设备
 */
- (void)connectorDidFailToConnectDevice:(BKDevice *)device error:(NSError *)error{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidFailToConnectDevice:error:)]) {
            [delegate connectorDidFailToConnectDevice:device error:error];
        }
    }];
}

/**
 连接超时
 */
- (void)connectorDidConnectTimeout{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidConnectTimeout)]) {
            [delegate connectorDidConnectTimeout];
        }
    }];
}


#pragma mark - connect delegate

#pragma mark required
/**
 *  invoked when the device did connected by the centeral
 *
 *  @param device the device did connected
 */
- (void)solsticeDidConnectDevice:(ZRBlePeripheral *)device{
    AXCachedLogOBJ(device);
    if ([self respondsToSelector:@selector(connectorDidConnectedDevice:)]) {
        [self connectorDidConnectedDevice:device.transformToBKDevice];
    }
}

#pragma mark optional

/**
 Invoked when the device did disConnect with the connectted centeral
 
 @param device The device whom the centeral was connected
 @param error In most cases it is nil
 */
- (void)solsticeDidDisConnectWithDevice:(ZRBlePeripheral *)device andError:(NSError *)error{
    AXCachedLogOBJ(device);
    if ([self respondsToSelector:@selector(connectorDidUnconnectedDevice:error:)]) {
        [self connectorDidUnconnectedDevice:device.transformToBKDevice error:error];
    }
}
/**
 Invoked when the device did fail to connected by the centeral
 
 @param device The device whom the centeral want to be connected
 @param error In most cases it is nil
 */
- (void)solsticeDidFailToConnectDevice:(ZRBlePeripheral *)device andError:(NSError *)error{
    AXCachedLogOBJ(device);
    if ([self respondsToSelector:@selector(connectorDidFailToConnectDevice:error:)]) {
        [self connectorDidFailToConnectDevice:device.transformToBKDevice error:error];
    }
}

/**
 *  invoked when connect more than 10 second.
 */
- (void)solsticeConnectTimeOut{
    AXCachedLogOBJ(@"connect time out");
    if ([self respondsToSelector:@selector(connectorDidConnectTimeout)]) {
        [self connectorDidConnectTimeout];
    }
}

/**! Bluetooth state changed off.*/
- (void)centralManagerStatePoweredOff{
    AXCachedLogOBJ(@"power off");
}
/**! Bluetooth state changed on.*/
- (void)centralManagerStatePoweredOn{
    AXCachedLogOBJ(@"power on");
}



//#pragma mark required
//
//- (void)solsticeDidConnectDevice:(ZRBlePeripheral *)device{
//    AXCachedLogOBJ(device);
//    _state = BKConnectStateConnected;
//    _device = device.transformToBKDevice;
//    [[BKServices sharedInstance] registerConnectDelegate:self.device];
//    [[BKServices sharedInstance] registerDataObserver:self.device];
//    _peripheral = device.cbDevice;
//    [[_BKBLEManager currentManager] registerSolsticeEquinox:self];
////    [BLELib3 shareInstance].delegate = self.device;
//    [self.central connectPeripheral:self.peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,CBConnectPeripheralOptionNotifyOnNotificationKey:@YES}];
//    if ([self.delegate respondsToSelector:@selector(connectorDidConnectedDevice:)]) {
//        [self.delegate connectorDidConnectedDevice:device.transformToBKDevice];
//    }
//}
//
//#pragma mark optional
///**
// *   @see BLEParamSign
// *   设置蓝牙参数，默认 BLEParamSignConnect
// */
//- (BLEParamSign)bleParamSignSetting{
//    AXCachedLogOBJ(@"设置蓝牙参数，默认 BLEParamSignConnect");
//    return BLEParamSignConnect;
//}
//
//
///**
// *  invoked when the device did disConnect with the connectted centeral
// *
// *  @param device the device whom the centeral was connected
// */
//- (void)IWBLEDidDisConnectWithDevice:(ZeronerBlePeripheral *)device andError:(NSError *)error{
//    AXCachedLogOBJ(device);
//    AXCachedLogError(error);
//    if (self.state == BKConnectStateConnected) {
//        // 如果当前状态是已连接，就需要更新状态为未连接
//        _state = BKConnectStateBindingUnconnected;
//    }
//
//    if (self.peripheral) {
//        [self.central cancelPeripheralConnection:self.peripheral];
//    }
//    if ([self.delegate respondsToSelector:@selector(connectorDidUnconnectedDevice:)]) {
//        [self.delegate connectorDidUnconnectedDevice:device.transformToBKDevice];
//    }
//
//    // 移除掉代理，不再接收事件
//    [[BKServices sharedInstance] unRegisterConnectDelegate:self.device];
//    [[BKServices sharedInstance] unRegisterDataObserver:self.device];
//    _device = nil;
//    self.device.delegate = nil;
//}
//
///**
// *  invoked when the device did fail to connected by the centeral
// *
// *  @param device the device whom the centeral want to be connected
// */
//- (void)IWBLEDidFailToConnectDevice:(ZeronerBlePeripheral *)device andError:(NSError *)error{
//    AXCachedLogOBJ(device);
//    AXCachedLogError(error);
//    if (device) {
//        _state = BKConnectStateBindingUnconnected;
//    } else {
//        _state = BKConnectStateUnknown;
//    }
//
//    if ([self.delegate respondsToSelector:@selector(connectorDidFailToConnectDevice:)]) {
//        [self.delegate connectorDidFailToConnectDevice:device.transformToBKDevice];
//    }
//
//    self.device.delegate = nil;
//}
//
///**
// *  invoked when connect more than 10 second.
// */
//- (void)IWBLEConnectTimeOut{
//    AXCachedLogError(@"连接超时");
//    _state = BKConnectStateUnknown;
//
//    if ([self.delegate respondsToSelector:@selector(connectorDidConnectTimeout)]) {
//        [self.delegate connectorDidConnectTimeout];
//    }
//
//    self.device.delegate = nil;
//}
//
///**
// *  表示手环注册ANCS失败，此时消息推送不能work，需要重新配对。
// *  This method would be invoked when the Peripheral disConnected with the system; In this case ,your app should tell the user who could ingore the device on system bluetooth ,and reconnect and pair the device. or there will be risk of receiving a message reminder.
// *
// *  @param deviceName the Device Name
// */
//- (void)deviceDidDisConnectedWithSystem:(NSString *)deviceName{
//    AXCachedLogOBJ(deviceName);
//    AXCachedLogError(@"手环注册ANCS失败，此时消息推送不能work，需要重新配对。");
//}
//
///**
// *  this method would be invoked when the app connected a device who is supportted by protocol2_0
// *  当前手环是2.0协议的手环是调用这个方法。
// */
//- (void)didConnectProtocolNum2_0{
//    AXCachedLogOBJ(@"当前手环是2.0协议的手环");
//}
//
///**
// *  Bluetooth state changed.
// *  检测到蓝牙状态变化
// */
//- (void)centralManagerStatePoweredOff{
//    AXCachedLogOBJ(@"蓝牙关");
//
//}
//- (void)centralManagerStatePoweredOn{
//    AXCachedLogOBJ(@"蓝牙开");
//
//}




@end
