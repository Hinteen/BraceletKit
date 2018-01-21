//
//  _BKModelHelper.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "_BKModelHelper.h"
#import "BKDatabase.h"


@implementation _BKModelHelper

@end

@implementation ZeronerBlePeripheral (BKExtension)

- (BKDevice *)transformToBKDevice{
    BKDevice *bk = [BKDevice new];
    bk.mac = self.mediaAC;
    bk.name = self.deviceName;
    bk.uuid = self.uuidString;
    bk.peripheral = self.cbDevice;
    bk.rssi = self.RSSI;
    bk.zeronerBlePeripheral = self;
    if ([bk.mac isEqualToString:@"advertisementData.length is less than 6"]) {
        bk.mac = bk.restoreMac;
    }
    return bk;
}

@end

