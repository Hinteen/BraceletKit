//
//  BKDeviceSetting.m
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDeviceSetting.h"
#import <BLE3Framework/BLE3Framework.h>
#import "_BKModelHelper.h"


@implementation BKDeviceSetting

- (void)applyToDevice{
    [[BLELib3 shareInstance] setFirmwareOption:self.transformToZeronerHWOption];
}

@end
