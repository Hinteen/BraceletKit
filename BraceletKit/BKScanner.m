//
//  BKScanner.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKScanner.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "_BKModelHelper.h"
#import "BKServices.h"
#import "BKSession.h"


@interface BKScanner() <CBCentralManagerDelegate, BleDiscoverDelegate, BKScanDelegate>

@property (strong, nonatomic) NSMutableArray<BKDevice *> *devices;

@property (strong, nonatomic) NSMutableArray<NSObject<BKScanDelegate> *> *scanDelegates;

@end

@implementation BKScanner


- (instancetype)init{
    if (self = [super init]) {
        _devices = [NSMutableArray array];
        self.scanDelegates = [NSMutableArray array];
    }
    return self;
}


- (void)registerScanDelegate:(NSObject<BKScanDelegate> *)delegate{
    if (delegate && ![self.scanDelegates containsObject:delegate]) {
        [self.scanDelegates addObject:delegate];
    }
}

- (void)unRegisterScanDelegate:(NSObject<BKScanDelegate> *)delegate{
    if (delegate && [self.scanDelegates containsObject:delegate]) {
        [self.scanDelegates removeObject:delegate];
    }
}


- (void)scanDevice{
    [[BKSession sharedInstance] requestScanDevice:YES completion:^{
        AXCachedLogOBJ(@"开始扫描");
    } error:^(NSError * _Nullable error) {
        AXCachedLogError(error);
    }];
}

- (void)stopScan{
    [[BKSession sharedInstance] requestScanDevice:NO completion:^{
        AXCachedLogOBJ(@"停止扫描");
    } error:^(NSError * _Nullable error) {
        AXCachedLogError(error);
    }];
}

- (void)allScannerDelegates:(void (^)(NSObject<BKScanDelegate> *delegate))handler{
    [self.scanDelegates enumerateObjectsUsingBlock:^(NSObject<BKScanDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}

#pragma mark - discover delegate

/**
 SDK发现设备
 
 @param device 设备
 */
- (void)scannerDidDiscoverDevice:(BKDevice *)device{
    [self.devices addObject:device];
    [self allScannerDelegates:^(NSObject<BKScanDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(scannerDidDiscoverDevice:)]) {
            [delegate scannerDidDiscoverDevice:device];
        }
    }];
}


/**
 CentralManager状态改变
 
 @param central CentralManager
 */
- (void)scannerForCentralManagerDidUpdateState:(CBCentralManager *)central{
    [self allScannerDelegates:^(NSObject<BKScanDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(scannerForCentralManagerDidUpdateState:)]) {
            [delegate scannerForCentralManagerDidUpdateState:central];
        }
    }];
}

/**
 CentralManager发现设备
 
 @param device 设备
 */
- (void)scannerForCentralManagerDidDiscoverDevice:(BKDevice *)device{
    [self allScannerDelegates:^(NSObject<BKScanDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(scannerForCentralManagerDidDiscoverDevice:)]) {
            [delegate scannerForCentralManagerDidDiscoverDevice:device];
        }
    }];
}



#pragma mark - cbcentral delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    [self scannerForCentralManagerDidUpdateState:central];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
}


#pragma mark - discover delegate
#pragma mark required

/**
 * This method is invoked while scanning
 
 @param iwDevice Instance contain a CBPeripheral object and the device's MAC address
 */
- (void)solsticeDidDiscoverDeviceWithMAC:(ZRBlePeripheral *)iwDevice{
    AXCachedLogOBJ(iwDevice);
    [self scannerDidDiscoverDevice:iwDevice.transformToBKDevice];
    //    if ([BKServices sharedInstance].connector.state == BKConnectStateBindingUnconnected) {
    //        if ([device.mac isEqualToString:[BKDevice currentDevice].mac]) {
    //            [[BKServices sharedInstance].connector connectDevice:device];
    //        }
    //    }
}

/**
 * Search stopped
 */
- (void)solsticeStopScan{
    AXCachedLogOBJ(@"stop scan");
}


@end
