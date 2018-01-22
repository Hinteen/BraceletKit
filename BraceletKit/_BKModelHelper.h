//
//  _BKModelHelper.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AXKit/AXKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <BLE3Framework/BLE3Framework.h>
#import "BKDevice.h"
#import "BKDeviceSetting.h"


@interface _BKModelHelper : NSObject




@end

@interface ZeronerBlePeripheral (BKExtension)

- (BKDevice *)transformToBKDevice;

@end

@interface ZeronerHWOption (BKExtension)

- (BKDeviceSetting *)transformToBKDeviceSetting;

@end

@interface BKDeviceSetting (BKExtension)

- (ZeronerHWOption *)transformToZeronerHWOption;

@end

