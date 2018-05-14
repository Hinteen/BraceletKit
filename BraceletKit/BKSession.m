//
//  BKSession.m
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSession.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "_BKHeader.h"



//static inline void bk_ble_option(void (^option)(void), void(^completion)(void), void (^error)(NSError * __nullable)){
//    CBCentralManagerState state = (CBCentralManagerState)[BKServices sharedInstance].connector.central.state;
//    BOOL ble = state == CBCentralManagerStatePoweredOn;
//    if (!ble) {
//        NSError *err = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
//            if (state == CBCentralManagerStatePoweredOff) {
//                error.localizedDescription = @"蓝牙未打开";
//            } else if (state == CBCentralManagerStateUnauthorized) {
//                error.localizedDescription = @"蓝牙未授权";
//            } else if (state == CBCentralManagerStateUnsupported) {
//                error.localizedDescription = @"设备不支持蓝牙4.0";
//            } else {
//                error.localizedDescription = @"未能打开蓝牙，原因未知。";
//            }
//        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [AXStatusBar showStatusBarMessage:err.localizedDescription textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
//        });
//        if (error) {
//            error(err);
//        }
//        return;
//    }
    
//    BOOL device = [BKDevice currentDevice];
//    if (!device) {
//        NSError *err = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
//            error.localizedDescription = @"未连接任何设备";
//        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [AXStatusBar showStatusBarMessage:err.localizedDescription textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
//        });
//        if (error) {
//            error(err);
//        }
//        return;
//    }

//    BOOL connected = [BKServices sharedInstance].connector.state == BKConnectStateConnected;
//    if (!connected) {
//        NSError *err = [NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
//            error.localizedDescription = @"与设备的连接已经断开";
//        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [AXStatusBar showStatusBarMessage:err.localizedDescription textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
//        });
//        if (error) {
//            error(err);
//        }
//        return;
//    }
    
//    if (option) {
//        option();
//        if (completion) {
//            completion();
//        }
//    }
//
//}

static BKSession *session;


@interface BKSession() <BLEquinox, BKConnectDelegate>

//@property (strong, nonatomic) BLEAutumn *manager;

@property (strong, nonatomic) dispatch_queue_t cmdQueue;

//@property (weak, nonatomic) id<BLESolstice>solstice;

@property (nonatomic, strong) NSMutableArray <NSObject<BKSessionDelegate> *> *delegates;

+ (id<BLESolstice>)solstice;

@end

@interface BKScanner() <BleDiscoverDelegate>
@end

@interface BKConnector() <BleConnectDelegate>
@end

@interface BKDevice() <BLEquinox>
@end

@implementation BKSession

+ (instancetype)sharedInstance{
    if (!session) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            session = [self requestWithDeviceClass:BKDeviceClassColorful];
        });
    }
    return session;
}

+ (id<BLESolstice>)solstice {
    return [[BKSession sharedInstance] solstice];
}

+ (instancetype)requestWithDeviceClass:(BKDeviceClass)deviceClass{
    return [[self alloc] initWithDeviceClass:deviceClass];
}

- (instancetype)initWithDeviceClass:(BKDeviceClass)deviceClass{
    if (self = [self init]) {
        self.deviceClass = deviceClass;
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    self.cmdQueue = dispatch_queue_create("com.hinteen.braceletkit.request", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(self.cmdQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    
    _delegates = [NSMutableArray array];
    
    self.manager = [BLEAutumn midAutumn:BLEProtocol_Any];

    
    _scanner = [BKScanner sharedInstance];
    _connector = [BKConnector sharedInstance];
    
    [_connector registerConnectDelegate:self];
    
    self.manager.discoverDelegate = self.scanner;
    self.manager.connectDelegate = self.connector;
    
//    bool bl = [self.manager registerSolsticeEquinox:self];
    
    return self;
}

- (void)registerDelegate:(NSObject<BKSessionDelegate> *)delegate{
    if (delegate && ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void)unRegisterDelegate:(NSObject<BKSessionDelegate> *)delegate{
    if (delegate && [self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
    }
}

- (void)allDelegates:(void (^)(NSObject<BKSessionDelegate> *delegate))handler{
    [self.delegates enumerateObjectsUsingBlock:^(NSObject<BKSessionDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}

- (void)safeRequest:(void (^)(BLEAutumn *manager, id<BLESolstice>solstice))option completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error{
//    NSLog(@"Manager : %@_________Solstice : %@",_manager,_solstice);
    if (option) {
        dispatch_async(self.cmdQueue, ^{
            option(self.manager, self.solstice);
        });
        if (completion) {
            completion();
        }
    }
}

- (void)requestScanDevice:(BOOL)scan completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        if (scan) {
            [manager startScan];
        } else {
            [manager stopScan];
        }
    } completion:completion error:error];
}

- (void)requestBindDevice:(BKDevice *)device completion:(void (^)(void))completion error:(void (^)(NSError * _Nullable))error{
    if (device.zrPeripheral) {
        [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
            [manager bindDevice:device.zrPeripheral];
        } completion:completion error:error];
    } else {
        if (error) {
            error([NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
                error.localizedDescription = @"无效的设备";
            }]);
        }
    }
    
}

- (void)requestUnbindDevice:(BKDevice * _Nullable)device completion:(void (^)(void))completion error:(void (^)(NSError * _Nullable))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [manager unbind];
        [solstice debindFromSystem];
    } completion:completion error:error];
}

- (void)requestReconnectDevice:(BKDevice * _Nullable)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [manager reConnectDevice];
    } completion:completion error:error];
}


/**
 请求同步用户数据
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateUser:(BKUser *)user completion:(void (^)(void))completion error:(void (^)(NSError * _Nonnull))error{
    if (user.transformToZRPersonal) {
        [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
            [solstice setPersonalInfo:user.transformToZRPersonal];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), self.cmdQueue, ^{
                [solstice readPersonalInfo];
            });
        } completion:completion error:error];
    } else {
        if (error) {
            error([NSError ax_errorWithMaker:^(NSErrorMaker * _Nonnull error) {
                error.localizedDescription = @"无效的用户";
            }]);
        }
    }
}

/**
 请求更新偏好设置
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdatePreferences:(BKPreferences *)preferences completion:(void (^)(void))completion error:(void (^)(NSError * _Nonnull))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setDeviceOption:preferences.transformToZRHWOption];
        //to modify
//        [solstice setCustomOptions:preferences.transformToZRCOption];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), self.cmdQueue, ^{
            [solstice readDeviceOption];
            [solstice readCustomOptions];
        });
    } completion:completion error:error];
}

/**
 请求立即同步时间
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestSyncTimeAtOnceCompletion:(void (^)(void))completion error:(void (^)(NSError * _Nonnull))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice syscTimeAtOnce];
    } completion:completion error:error];
}

/**
 请求进入或退出拍照模式
 
 @param cameraMode 进入或退出
 @param completion 指令已发送到设备
 @param error 操作失败
 */
- (void)requestCameraMode:(BOOL)cameraMode completion:(void(^)(void))completion error:(void (^)(NSError * _Nonnull))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setKeyNotify:(BKeyNotify)(cameraMode * BKN_SET_SmartPhoto)];
    } completion:completion error:error];
}
- (void)requestFindPhoneMode:(BOOL)findPhoneMode completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setKeyNotify:(BKeyNotify)(findPhoneMode * BKN_GET_SearchPhone)];
    } completion:completion error:error];
}
- (void)requestUpdateNotifyMode:(NSInteger)keyNotify completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError * _Nullable error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setKeyNotify:keyNotify];
    } completion:completion error:error];
}
/**
 请求向手环推送消息（不要超过手环一屏内容，否则显示不全）
 
 @param message 消息内容
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestPushMessage:(NSString *)message completion:(void (^)(void))completion error:(void (^)(NSError * _Nonnull))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice pushStr:message];
    } completion:completion error:error];
}

/**
 请求更新电池电量信息
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateBatteryCompletion:(void(^)(void))completion error:(void (^)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [self.solstice readDeviceBattery];
    } completion:completion error:error];
}

/**
 请求更新所有健康数据
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateAllHealthDataCompletion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice getDataStoreDate];
    } completion:completion error:error];
}

- (void) requestUpdateSpecialDataCompletion:(NSDate *)date completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice> solstice) {
        [solstice startSpecialData:SD_TYPE_SPORT withDate:date];
    } completion:completion error:error];
}

/**
 请求立即停止更新所有健康数据
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestStopUpdateAllHealthDataCompletion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
//        [[BLELib3 shareInstance] stopSyncData];
    } completion:completion error:error];
}

/**
 请求更新天气信息
 
 @param completion 指令已发送到设备
 @param error 指令发送失败及其原因
 */
- (void)requestUpdateWeatherInfo:(void (^)(BKWeather *weather))weatherInfo completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    if (weatherInfo) {
        [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
            BKWeather *weather = [[BKWeather alloc] init];
            weatherInfo(weather);
            [solstice setWeather:(ZRWeather *)weather];
        } completion:completion error:error];
    }
}

- (void)requestUpdateDNDMode:(void (^)(BKDNDMode * _Nonnull))dndMode completion:(void (^)(void))completion error:(void (^)(NSError * _Nonnull))error{
    if (dndMode) {
        [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
            BKDNDMode *dnd = [[BKDNDMode alloc] init];
            dndMode(dnd);
            [solstice setDNDMode:dnd.transformToZRDNDModel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), self.cmdQueue, ^{
                [solstice readDNDModeInfo];
            });
        } completion:completion error:error];
    }
}
- (void)requestReadDeviceInfo:(BKDevice * _Nullable)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice readDeviceInfo];
    } completion:completion error:error];
}

- (void)requestReadDeviceBattery:(BKDevice *)device completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice readDeviceBattery];
    } completion:completion error:error];
}

- (void)requestReadSportTargets:(BKSportTarget *)sportTarget completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice readSportTargets];
    } completion:completion error:error];
}

- (void)requestReadSedentary:(BKSedentary *)sedentary completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice readSedentary];
    } completion:completion error:error];
}

- (void)requestReadSpecialList:(NSInteger)rId completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice readSpecialList:rId];
    } completion:completion error:error];
}

- (void)requestReadAllList:(BKRoll *)roll completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice readAllList];
    } completion:completion error:error];
}

- (void)requestReadSupportedSport:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice readSupportSports];
    } completion:completion error:error];
}



- (void)requestUpdateAlarmClock:(BKAlarmClock *)alarmClock completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setAlarmClock:alarmClock.transformToZRClock];
    } completion:completion error:error];
}

- (void)requestUpdateSedentary:(BKSedentary *)sedentary completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setSedentary:sedentary.transformToZRSedentary];
    } completion:completion error:error];
}

- (void)requestUpdateSchedule:(BKSchedule *)schedule completion:(void(^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setSchedule:schedule.transformToZRSchedule];
    } completion:completion error:error];
}

- (void)requestUpdateMotor:(BKMotor *)motor completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setMotors:[BKMotor defaultMotors]];
    } completion:completion error:error];
}

- (void)requestUpdateSportTarget:(BKSportTarget *)sportTarget completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice setSportTarget:(ZRSportTarget *)sportTarget];
    } completion:completion error:error];
}

- (void)requestUpdateSpecialList:(NSArray <BKRoll *>*)rolls completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice addSpecialList:(NSArray <ZRRoll *>*)rolls];
    } completion:completion error:error];
}





- (void)requestClearAllClocks:(BKSchedule *)schedule completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice clearAllClocks];
    } completion:completion error:error];
}

- (void)requestClearAllSchedule:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice clearAllSchedules];
    } completion:completion error:error];
}

- (void)requestRemoveSpecialList:(NSArray <BKRoll *>*)rolls completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice removeSpecialList:(NSArray <ZRRoll *>*)rolls];
    } completion:completion error:error];
}

- (void)requestClearAllLists:(BKRoll *)roll completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice clearAllLists];
    } completion:completion error:error];
}

- (void)requestCloseSchedule:(BKSchedule *)schedule completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice closeSchedule:(ZRSchedule *)schedule];
    } completion:completion error:error];
}




- (void)requestFeelMotor:(BKMotor *)motor completion:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice feelMotor:motor];
    } completion:completion error:error];
}

- (void)requestUpdateDevice:(void (^ _Nullable)(void))completion error:(void (^ _Nullable)(NSError *error))error{
    [self safeRequest:^(BLEAutumn *manager, id<BLESolstice>solstice) {
        [solstice deviceUpgrade];
    } completion:completion error:error];
}

#pragma mark - Connect Delegate


- (void)connectorDidConnectedDevice:(BKDevice *)device{
    self.solstice = self.manager.solstice;
    [self.manager registerSolsticeEquinox:self];
    //    [self.manager registerSolsticeEquinox:device];
}

#pragma mark - ble delegate

#pragma mark required
/**
 * After the connection is established, the SDK needs some basic setup, which takes a few seconds. After this, will call back this method, you might need read some infomation in device ,You are advised to call some methods here, like @CODE{readDeviceInfo} @CODE{readDeviceBattery}. Or do device setting in method @CODE{setBLEParameterAfterConnect}
 In <BLEProtocol_colorful> device ,these methods would not be invoked when you had implement method responseOfConnectStatus:
 */
- (void)readRequiredInfoAfterConnect{
    AXCachedLogOBJ(@"");
}
/**
 *  I suggest you here to complete the need for other operations.
 */
- (void)setBLEParameterAfterConnect{
    AXCachedLogOBJ(@"");
}

#pragma mark optional

/**
 *  This method would be invoked when the app connected a device who is supportted by protocol2_0
 *  当前手环是2.0协议的手环是调用这个方法。
 */
- (void)didConnectProtocolNum2_0{
    AXCachedLogOBJ(@"");
}


/**
 * The connection status is abnormal, it usually does not happen. If it appears, restart the Bluetooth and device.
 * Used for <BLEProtocol_colorful> device.
 * 连接状态异常，通常不会发生，如有出现，请重启蓝牙和设备。
 */
- (void)responseOfConnectStateError{
    AXCachedLogError(@"");
}

/**
 * 声明：蓝牙日志的解读需要ZR蓝牙协议的文档，如果你没有阅读文档的权限，身边也没有可以阅读此文档的人，那么写日志对你来说不是必要的。
 * 传一个地址，如果你需要蓝牙的日志的话，最好是txt格式的。
 * Return a file path for BLE log, you are expected return a file path type txt. like this
 * @code
 NSString *documentsPath =[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
 NSString *testPath = [documentsPath stringByAppendingPathComponent:@"BLE.txt"];
 return testPath;
 @endcode
 */
- (NSString *)bleLogPath{
    return nil;
}

/**
 * Description: APP initiative call setKeyNotify: 1, let the bracelet into the camera mode, camera button appears on the ring,
 Press the button or click the button The bracelet SDK will notify the App through notifyToTakePicture photo.
 Note: setKeyNotify into App mode after setting 1. Exit the camera interface to set 0
 Need to do photo protection, take pictures before saving is complete Do not open the second photo.
 Description: Long press the ring button or click the touch screen to select the phone button, the ring SDK will notify App via notifyToSearchPhone, the ring needs to find the phone.
  * Next App can play music or other operation to find the phone
 
 @param bkn Operation events type
 */
- (void)responseKeyNotify:(BKeyNotify)bkn{
    AXCachedLogOBJ(NSStringFromNSInteger(bkn));
}


/**
 Most read status operations will be returned in this method, including device information, device power and so on.
 Distinguished by the type of BLECmdResponse.
 
 @param response  @{"type" : BLECmdResponse,"data" : id}
 */

- (void)readResponseFromDevice:(ZRReadResponse *)response{
    AXCachedLogOBJ(response);
    if (response.cmdResponse == CMD_RESPONSE_DEVICE_GET_BATTERY) {
        ZRDeviceInfo *deviceInfo = response.data;
        [BKDevice currentDevice].battery = deviceInfo.batLevel;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateBattery:)]) {
                [delegate deviceDidUpdateBattery:[BKDevice currentDevice].battery];
            }
        }];
    } else if (response.cmdResponse == CMD_RESPONSE_DEVICE_GET_INFORMATION){
        ZRDeviceInfo *deviceInfo = response.data;
        [BKDevice currentDevice].model =deviceInfo.model;
        [BKDevice currentDevice].version =deviceInfo.version;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateInfo)]) {
                [delegate deviceDidUpdateInfo];
            }
        }];
    }
}

/**
 *  Method would be invoked when syscData state changed
 *  @param ksdState type means sysc finished process.
 */
- (void)syscDataFinishedStateChange:(KSyscDataState)ksdState{
    AXCachedLogOBJ(NSStringFromNSInteger(ksdState));
}



/**
 Return data information
 
 @param zrDInfo Contain dataType,date,seqStart,seqEnd and more.
 */
- (void)updateNormalHealthDataInfo:(ZRDataInfo *)zrDInfo{
    AXCachedLogOBJ(zrDInfo);
    if (zrDInfo.dataType == ZRDITypeHbridHealth || zrDInfo.dataType == ZRDITypeNormalData) {
        NSDate *dateInfo =zrDInfo.ddInfos[0].date;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateNormalHealthDataInf:)]) {
                [delegate deviceDidUpdateNormalHealthDataInf:dateInfo];
            }
        }];
    }
}


///**
// Return data.
// 
// @param zrhData See more in ZRHealthData.h
// */
//- (void)updateNormalHealthData:(ZRHealthData *)zrhData{
//    AXCachedLogOBJ(zrhData);
//    [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
//        if ([delegate respondsToSelector:@selector(deviceDidUpdateSummaryData:)]) {
//            [delegate updateNormalHealthData:(BKHealthData *)zrhData];
//        }
//    }];
//    if ([zrhData isKindOfClass:[ZRSummaryData class]]) {
//        BKSummaryData *summaryData = (BKSummaryData *)zrhData;
//        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
//            if ([delegate respondsToSelector:@selector(deviceDidUpdateSummaryData:)]) {
//                [delegate deviceDidUpdateSummaryData:summaryData];
//            }
//        }];
//    }
//    else if ([zrhData isKindOfClass:[ZRSportData class]]) {
//        BKSportData *sportData = (BKSportData *)zrhData;
//        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
//            if ([delegate respondsToSelector:@selector(deviceDidUpdateSportData:)]) {
//                [delegate deviceDidUpdateSportData:sportData];
//            }
//        }];
//    }
//    
//}

/**
 Return data.
 
 @param zrhData See more in ZRHealthData.h
 */
- (void)updateNormalHealthData:(ZRHealthData *)zrhData{
    AXCachedLogOBJ(zrhData);
    [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(updateNormalHealthData:)]) {
            [delegate updateNormalHealthData:zrhData];
        }
    }];
    if ([zrhData isKindOfClass:[ZRHRateHoursData class]]){
        ZRHRateHoursData *hRateHoursData = (ZRHRateHoursData*) zrhData;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateHRateHoursData:)]) {
                [delegate deviceDidUpdateHRateHoursData:hRateHoursData];
            }
        }];
    }
    if ([zrhData isKindOfClass:[ZRSleepData class]]){
        ZRSleepData *sleepData = (ZRSleepData*) zrhData;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateSleepData:)]) {
                [delegate deviceDidUpdateSleepData:sleepData];
            }
        }];
    }
    if ([zrhData isKindOfClass:[ZRSummaryData class]]) {
        BKSummaryData *summaryData = (BKSummaryData *)zrhData;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateSummaryData:)]) {
                [delegate deviceDidUpdateSummaryData:summaryData];
            }
        }];
    }
    else if ([zrhData isKindOfClass:[ZRSleepData class]]) {
        ZRSleepData *sleepData = (ZRSleepData *)zrhData;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateSleepData:)]) {
                [delegate deviceDidUpdateSleepData:sleepData];
            }
        }];
    }
    else if ([zrhData isKindOfClass:[ZRHRateHoursData class]]) {
        ZRHRateHoursData *hRateHoursData = (ZRHRateHoursData *)zrhData;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateHRateHoursData:)]) {
                [delegate deviceDidUpdateHRateHoursData:hRateHoursData];
            }
        }];
    }
    else if ([zrhData isKindOfClass:[ZRStepData class]]) {
        ZRStepData *stepData = (ZRStepData *)zrhData;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateStepData:)]) {
                [delegate deviceDidUpdateStepData:stepData];
            }
        }];
    }
    else if ([zrhData isKindOfClass:[ZRSportData class]]) {
        ZRSportData *sportData = (ZRSportData *)zrhData;
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(deviceDidUpdateSportData:)]) {
                [delegate deviceDidUpdateSportData:sportData];
            }
        }];
    }
    
}


/**! Successfully disconnected, you can call the unbinding method here.*/
- (void)debindFromBraceletSuccessful{
    AXCachedLogOBJ(@"");
}


/**
 This method can get the connection status, when isReady == YES indicates that the communication is established, otherwise most of the business communication is not available. The SDK has its own RCC(Rotation Check Communication) method to set the connection status. You can also control it yourself by implementing this method and the two command methods setBleConnectStatus && getConnectionStatus.
 RCC(轮询检查通信) refers to the SDK after looping through reading and writing to get the correct connection status and handle some basic operations. In case of opening RCC, the interface method of SDK is readRequiredInfoAfterConnect && setBLEParameterAfterConnect. Or SDK would not invoke these two method ,interface instead by this method.
 After you have implemented this method, the SDK's RCC will not work.
 
 @param isReady YES means communication is OK, or you need call setBleConnectStatus to let device in ready.
 */
- (void)responseOfConnectStatus:(BOOL)isReady{
//    AXCachedLogOBJ(NSStringFromBool(isReady));
    NSLog(@"Ready : %d",isReady);
    if (isReady) {
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(connectionIsReadyToSend)]) {
                [delegate connectionIsReadyToSend];
            }
        }];
    }else{
        [self.solstice setBleConnectStatus];
        [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
            if ([delegate respondsToSelector:@selector(connectionIsNotReadyToSend)]) {
                [delegate connectionIsNotReadyToSend];
            }
        }];
    }
}

- (void)responseOfGetDataTimeOutWithDataType:(NSInteger)type {
    [self.solstice setBleConnectStatus];
    [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectionIsReadyToSend)]) {
            [delegate connectionTimeOut:type];
        }
    }];
}

- (void)solsticeConnectTimeOut {
    [self.solstice setBleConnectStatus];
    [self allDelegates:^(NSObject<BKSessionDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectionIsReadyToSend)]) {
            [delegate bindingConnectionTimeOut];
        }
    }];
}

/**
 当获取8900、8901、8902、8903、8904类型的数据的时候，写指令发出后，没有收到手环传回的数据，就会调取这个回调；
 app可以根据这个回调方法，在方法内部给同步进度的progress做虚拟值赋值处理；
 
 @param type 8900、8901、8902、8903、8904
 */
//- (void)responseOfGetDataTimeOutWithDataType:(NSInteger)type{
//    AXCachedLogOBJ(NSStringFromNSInteger(type));
//}

#pragma mark -FOTA

/**
 Transparent method, used with BtNotify. <BLEProtocol_watch> support
 
 @param cbc CBCharacteristic object
 */
- (void)responseOfMTKBtNotifyData:(CBCharacteristic *)cbc{
    AXCachedLogOBJ(cbc.UUID.UUIDString);
}

/**! Simlar to responseOfMTKBtNotifyData:*/
- (void)responseOfMTKBtWriteData:(CBCharacteristic *)cbc{
    AXCachedLogOBJ(cbc.UUID.UUIDString);
}


@end
