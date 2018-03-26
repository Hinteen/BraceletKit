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
#import <BLEMidAutumn/BLEMidAutumn.h>
#import "BKUser.h"
#import "BKDevice.h"
#import "BKPreferences.h"
#import "BKWeather.h"
#import "BKDNDMode.h"


@interface _BKModelHelper : NSObject




@end

@interface BKUser (BKExtension)

- (ZRPersonal *)transformToZRPersonal;

@end

@interface ZRBlePeripheral (BKExtension)

- (BKDevice *)transformToBKDevice;

@end
@interface BKDevice (BKModelExtension)

- (ZRBlePeripheral *)transformToZRBlePeripheral;

@end

@interface ZRHWOption (BKExtension)

- (BKPreferences *)transformToBKPreferences;

@end

@interface BKPreferences (BKExtension)

- (ZRHWOption *)transformToZRHWOption;
- (ZRCOption *)transformToZRCOption;

@end

@interface BKWeather (BKExtension)

- (ZRWeather *)transformToZRWeather;

@end


@interface BKDNDMode (BKModelExtension)

- (ZRDNDModel *)transformToZRDNDModel;

@end
