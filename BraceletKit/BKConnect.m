//
//  BKConnect.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKConnect.h"
#import "_BKModelHelper.h"
#import <AXKit/AXKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <BLE3Framework/BLE3Framework.h>


@interface BKConnect() <CBCentralManagerDelegate, CBPeripheralDelegate, BleDiscoverDelegate, BleConnectDelegate>

@property (strong, nonatomic) CBCentralManager *central;

@property (strong, nonatomic) CBPeripheral *peripheral;

@property (strong, nonatomic) BLELib3 *bleSDK;



@end

@interface BKDevice() <BLELib3Delegate>

@end

@implementation BKConnect

- (instancetype)init{
    if (self = [super init]) {
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        self.bleSDK = [BLELib3 shareInstance];
        self.bleSDK.discoverDelegate = self;
        self.bleSDK.connectDelegate = self;
        self.bleSDK.delegate = self.device;
    }
    return self;
}


- (instancetype)initWithDelegate:(NSObject<BKConnectDelegate> *)delegate{
    if (self = [self init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)scanDevice{
    [self.bleSDK scanDevice];
    AXCachedLogOBJ(@"开始扫描");
}

- (void)connectDevice:(BKDevice *)device{
    [self.bleSDK connectDevice:device.zeronerBlePeripheral];
    AXCachedLogOBJ(@"调用了连接方法");
}

- (void)disConnectDevice{
    [self.bleSDK unConnectDevice];
    [self.bleSDK debindFromSystem];
    AXCachedLogOBJ(@"调用了断开连接方法");
}





#pragma mark - discover delegate
#pragma mark required

/**
 * This method is invoked while scanning
 
 @param iwDevice Instance contain a CBPeripheral object and the device's MAC address
 */
- (void)IWBLEDidDiscoverDeviceWithMAC:(ZeronerBlePeripheral *)iwDevice{
    AXCachedLogOBJ(iwDevice);
    if ([self.delegate respondsToSelector:@selector(didDiscoverDevice:)]) {
        [self.delegate didDiscoverDevice:iwDevice.transformToBKDevice];
    }
}

#pragma mark optional
/**
 *
 *  @return Specifal services used for communication. For exeample, like bracelet, you should return  @{@"FF20",@"FFE5"}, you also should not implement this method if want to connect with zeroner's bracelet.
 */
//- (NSArray<NSString *> *)serverUUID{
//    return @[@"FF20", @"FFE5"];
//}

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
    [self.central connectPeripheral:self.peripheral options:nil];
    if ([self.delegate respondsToSelector:@selector(didConnectedDevice:)]) {
        [self.delegate didConnectedDevice:device.transformToBKDevice];
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
    if ([self.delegate respondsToSelector:@selector(didUnconnectedDevice:)]) {
        [self.delegate didUnconnectedDevice:device.transformToBKDevice];
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
    if ([self.delegate respondsToSelector:@selector(didFailToConnectDevice:)]) {
        [self.delegate didFailToConnectDevice:device.transformToBKDevice];
    }
}

/**
 *  invoked when connect more than 10 second.
 */
- (void)IWBLEConnectTimeOut{
    AXCachedLogError(@"连接超时");
    if ([self.delegate respondsToSelector:@selector(didConnectTimeout)]) {
        [self.delegate didConnectTimeout];
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


#pragma mark - system cb delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}


@end
