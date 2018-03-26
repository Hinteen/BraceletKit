//
//  BKDevice.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDevice.h"
#import "_BKHeader.h"
#import "BKServices.h"
#import <AXKit/StatusKit.h>

#import "BKUser.h"
#import "BKDevice.h"
#import "BKPreferences.h"
#import "BKDataIndex.h"
#import "BKDayData.h"
#import "BKSportData.h"
#import "BKHeartRateData.h"
#import "BKHeartRateHourData.h"
#import "BKSleepData.h"
#import "BKSportList.h"


static inline void bk_ble_option(void (^option)(void), void(^completion)(void), void (^error)(NSError * __nullable)){
    CBCentralManagerState state = (CBCentralManagerState)[BKServices sharedInstance].connector.central.state;
    BOOL ble = state == CBCentralManagerStatePoweredOn;
    if (!ble) {
        NSError *err = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
            if (state == CBCentralManagerStatePoweredOff) {
                error.localizedDescription = @"蓝牙未打开";
            } else if (state == CBCentralManagerStateUnauthorized) {
                error.localizedDescription = @"蓝牙未授权";
            } else if (state == CBCentralManagerStateUnsupported) {
                error.localizedDescription = @"设备不支持蓝牙4.0";
            } else {
                error.localizedDescription = @"未能打开蓝牙，原因未知。";
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [AXStatusBar showStatusBarMessage:err.localizedDescription textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
        });
        if (error) {
            error(err);
        }
        return;
    }
    
    BOOL device = [BKDevice currentDevice];
    if (!device) {
        NSError *err = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
            error.localizedDescription = @"未连接任何设备";
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [AXStatusBar showStatusBarMessage:err.localizedDescription textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
        });
        if (error) {
            error(err);
        }
        return;
    }
    
    BOOL connected = [BKServices sharedInstance].connector.state == BKConnectStateConnected;
    if (!connected) {
        NSError *err = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
            error.localizedDescription = @"与设备的连接已经断开";
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [AXStatusBar showStatusBarMessage:err.localizedDescription textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
        });
        if (error) {
            error(err);
        }
        return;
    }
    
    if (option) {
        option();
        if (completion) {
            completion();
        }
    }
    
}

@interface BKServices() <BKDeviceDelegate>

@end

@interface BKDevice() //<BKConnectDelegate, BKDataObserver>

//@property (strong, nonatomic) ZeronerDeviceInfo *deviceInfo;
//
//@property (strong, nonatomic) ZeronerHWOption *hwOption;

@property (assign, nonatomic) CGFloat progress;

@end

@implementation BKDevice

#pragma mark - life circle


+ (instancetype)currentDevice{
    return [BKServices sharedInstance].connector.device;
}

- (instancetype)init{
    if (self = [super init]) {
        _languages = [NSMutableArray array];
        _functions = [NSMutableArray array];
        _delegate = [BKServices sharedInstance];
        
    }
    return self;
}




@end

