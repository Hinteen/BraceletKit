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

@interface BKScanner() <CBCentralManagerDelegate, BleDiscoverDelegate>

@property (strong, nonatomic) CBCentralManager *central;

@end

@implementation BKScanner


- (instancetype)init{
    if (self = [super init]) {
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
        [BLELib3 shareInstance].discoverDelegate = self;
    }
    return self;
}



- (instancetype)initWithDelegate:(NSObject<BKScanDelegate> *)delegate{
    if (self = [self init]) {
        _delegate = delegate;
    }
    return self;
}


- (void)scanDevice{
    [[BLELib3 shareInstance] scanDevice];
    AXCachedLogOBJ(@"开始扫描");
}

- (void)stopScan{
    [[BLELib3 shareInstance] stopScan];
    AXCachedLogOBJ(@"停止扫描");
}



#pragma mark - cbcentral delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if ([self.delegate respondsToSelector:@selector(scannerForCentralManagerDidUpdateState:)]) {
        [self.delegate scannerForCentralManagerDidUpdateState:central];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    ZeronerBlePeripheral *model = [[ZeronerBlePeripheral alloc] initWith:peripheral andAdvertisementData:advertisementData];
    if ([self.delegate respondsToSelector:@selector(scannerForCentralManagerDidDiscoverDevice:)]) {
        [self.delegate scannerForCentralManagerDidDiscoverDevice:model.transformToBKDevice];
    }
}


#pragma mark - discover delegate
#pragma mark required

/**
 * This method is invoked while scanning
 
 @param iwDevice Instance contain a CBPeripheral object and the device's MAC address
 */
- (void)IWBLEDidDiscoverDeviceWithMAC:(ZeronerBlePeripheral *)iwDevice{
    AXCachedLogOBJ(iwDevice);
    if ([self.delegate respondsToSelector:@selector(scannerDidDiscoverDevice:)]) {
        [self.delegate scannerDidDiscoverDevice:iwDevice.transformToBKDevice];
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


@end
