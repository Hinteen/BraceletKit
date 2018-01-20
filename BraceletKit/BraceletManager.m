//
//  BraceletManager.m
//  BraceletKit
//
//  Created by xaoxuu on 25/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "BraceletManager.h"
#import <AXKit/AXKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AXKit/StatusKit.h>

static BraceletManager *braceletManager = nil;


static inline void showMessage(NSString *msg, NSTimeInterval duration){
    dispatch_async(dispatch_get_main_queue(), ^{
        // @xaoxuu: in main queue
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_blue] duration:duration];
    });
}

static inline void showAlert(NSString *msg){
    dispatch_async(dispatch_get_main_queue(), ^{
        // @xaoxuu: in main queue
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor blackColor] backgroundColor:[UIColor md_yellow] duration:5];
    });
}
static inline void showError(NSString *msg){
    dispatch_async(dispatch_get_main_queue(), ^{
        // @xaoxuu: in main queue
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:10];
    });
}

static inline void showSuccess(NSString *msg){
    dispatch_async(dispatch_get_main_queue(), ^{
        // @xaoxuu: in main queue
        [AXStatusBar showStatusBarMessage:msg textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:5];
    });
}

@interface BraceletManager () <CBCentralManagerDelegate, CBPeripheralDelegate>



// @xaoxuu: arr
@property (strong, nonatomic) NSMutableArray<ZeronerBlePeripheral *> *bindDevices;

@property (strong, nonatomic) CBCentralManager *central;

@property (strong, nonatomic) CBPeripheral *peripheral;

@end

@implementation BraceletManager

#pragma mark - life circle


+ (instancetype)defaultManager{
    return [self sharedInstance];
}

+ (instancetype)sharedInstance{
    if (!braceletManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            braceletManager = [[self alloc] init];
        });
    }
    return braceletManager;
}

#pragma mark init

- (instancetype)init{
    if (self = [super init]) {
        
    }
    self.delegates = [NSMutableArray array];
    self.bindDevices = [NSMutableArray array];
    // @xaoxuu: delegate
    self.bleSDK = [BLELib3 shareInstance];
    self.bleSDK.discoverDelegate = self;
    self.bleSDK.connectDelegate = self;
    self.bleSDK.delegate = self;
    
    self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    return self;
}

- (void)registerDelegate:(NSObject<BraceletManager> *)delegate{
//    for (NSObject<BraceletManager> * tmp in self.delegates) {
        // @xaoxuu: 注册过的类就不再重复注册
//        if ([NSStringFromClass([delegate class]) isEqualToString:NSStringFromClass([tmp class])]) {
//            return;
//        }
//    }
    if (delegate && ![self.delegates containsObject:delegate]) {
        [self.delegates addObject:delegate];
    }
}

- (void)unRegisterDelegate:(NSObject<BraceletManager> *)delegate{
    if (delegate && [self.delegates containsObject:delegate]) {
        [self.delegates removeObject:delegate];
    }
}

// @xaoxuu: 让所有的代理执行
- (void)allDelegates:(void (^)(NSObject<BraceletManager> * delegate))handler{
    [self.delegates enumerateObjectsUsingBlock:^(NSObject<BraceletManager> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}






- (void)scanDevice{
    [self.bleSDK scanDevice];
    AXCachedLogOBJ(@"开始扫描");
}


- (void)connectDevice:(ZeronerBlePeripheral *)device{
    [self.bleSDK connectDevice:device];
    AXCachedLogOBJ(@"调用了连接方法");
}
- (void)disConnectDevice{
    for (int i = 0; i < self.bindDevices.count; i++) {
        ZeronerBlePeripheral *tmp = self.bindDevices[i];
        if ([tmp.cbDevice isEqual:self.bleSDK.peripheral]) {
            [self.bindDevices removeObjectAtIndex:i];
            i--;
        }
    }
    [self.bleSDK unConnectDevice];
    [self.bleSDK debindFromSystem];
    AXCachedLogOBJ(@"调用了断开连接方法");
}

- (void)updateDeviceSetting:(void (^)(ZeronerHWOption *setting))setting{
    if (setting) {
        setting(self.currentDeviceSetting);
        [self.bleSDK setFirmwareOption:self.currentDeviceSetting];
    }
    
}


- (void)didConnectDevice:(ZeronerBlePeripheral *)device{
    BOOL added = NO;
    for (ZeronerBlePeripheral *tmp in self.bindDevices) {
        if ([tmp.uuidString isEqualToString:device.uuidString]) {
            added = YES;
            break;
        }
    }
    if (!added) {
        [self.bindDevices addObject:device];
    }
    
    
}


- (void)setCameraMode:(BOOL)cameraMode{
    _cameraMode = cameraMode;
    [self.bleSDK setKeyNotify:cameraMode];
}







#pragma mark - discover delegate
#pragma mark required

/**
 * This method is invoked while scanning
 
 @param iwDevice Instance contain a CBPeripheral object and the device's MAC address
 */
- (void)IWBLEDidDiscoverDeviceWithMAC:(ZeronerBlePeripheral *)iwDevice{
    AXCachedLogOBJ(iwDevice);
    [self allDelegates:^(NSObject<BraceletManager> * delegate) {
        if ([delegate respondsToSelector:@selector(braceletDidDiscoverDeviceWithMAC:)]) {
            [delegate braceletDidDiscoverDeviceWithMAC:iwDevice];
        }
    }];
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
    [self didConnectDevice:device];
    self.peripheral = device.cbDevice;
    [self.central connectPeripheral:self.peripheral options:nil];
    
    AXCachedLogOBJ(device);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ZeronerHWOption *model = [ZeronerHWOption defaultHWOption];
        model.ledSwitch = YES;
        model.unitType = UnitTypeInternational;
        model.backColor = YES;
        model.language = braceletLanguageSimpleChinese;
        model.disConnectTip = YES;
        model.autoHeartRate = YES;
        model.autoSleep = YES;
        model.findPhoneSwitch = YES;
        
        [self.bleSDK setFirmwareOption:model];
    });
    showSuccess(@"连接成功");
    
    
    
    
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
    
    if (self.peripheral) {
        [self.central cancelPeripheralConnection:self.peripheral];
    }
    if (device) {
        showError([NSString stringWithFormat:@"已与设备[%@]断开连接，错误信息：[%@]", device.deviceName, error]);
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
    showError([NSString stringWithFormat:@"与设备[%@]连接失败，错误信息：[%@]", device.deviceName, error]);
}

/**
 *  invoked when connect more than 10 second.
 */
- (void)IWBLEConnectTimeOut{
    AXCachedLogError(@"连接超时");
    showError(@"连接超时");
}

/**
 *  表示手环注册ANCS失败，此时消息推送不能work，需要重新配对。
 *  This method would be invoked when the Peripheral disConnected with the system; In this case ,your app should tell the user who could ingore the device on system bluetooth ,and reconnect and pair the device. or there will be risk of receiving a message reminder.
 *
 *  @param deviceName the Device Name
 */
- (void)deviceDidDisConnectedWithSystem:(NSString *)deviceName{
    AXCachedLogOBJ(deviceName);
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
    showError(@"蓝牙已关闭");
}
- (void)centralManagerStatePoweredOn{
    AXCachedLogOBJ(@"蓝牙开");
    showSuccess(@"蓝牙已打开");
}


#pragma mark - ble delegate -> device setting

#pragma mark required
/*
 *  Set bracelet parameter after connect with app.
 *  like ZeronerHWOption, ZeronerPersonal
 */
- (void)setBLEParameterAfterConnect{
    AXCachedLogOBJ(@"setBLEParameterAfterConnect");
}

#pragma mark - ble delegate -> device function


#pragma mark optional
/*
 * Implement this method and return YES if you are not want sysc data automaticlly.
 * Or SDK will call @method{syncData} after a little.
 * NOTE: You should set bracelet parameter in method @CODE{setBLEParameterAfterConnect} ,if you need lot of setting in there. You will be suggested return YES in finally.
 */
- (BOOL)doNotSyscHealthAtTimes{
    AXCachedLogOBJ(@"doNotSyscHealthAtTimes = YES");
    return YES;
}

/**
 * Invoked when sppcial cmd sent to device.
 * error equal nil mean successful.
 */
//- (BOOL)writeCmdResponse:(BLECmdResponse)type andError:(NSError *)error{
//
//}
/**
 * 声明：蓝牙日志的解读需要zeroner蓝牙协议的文档，如果你没有阅读文档的权限，身边也没有可以阅读此文档的人，那么写日志对你来说不是必要的。
 * 传一个地址，如果你需要蓝牙的日志的话，最好是txt格式的。
 * Return a file path for BLE log, you are expected return a file path type txt. like this
 * @code NSString *documentsPath =[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
 NSString *testPath = [documentsPath stringByAppendingPathComponent:@"BLE.txt"]; @/code
 */
- (NSString *)bleLogPath{
    NSString *path = [@"com.xaoxuu.AXKit" stringByAppendingPathComponent:@"log"];
    path = [path stringByAppendingPathComponent:@"ZeronerBleLog.txt"].cachePath;
    return path;
}
//- (NSString *)arithmeticLogPath{
//
//}
//- (NSString *)arithmeticLogDir{
//
//}
- (NSString *)currentUserUid{
    return @"123456";
}

/*!
 * 描述: APP主动call setKeyNotify:1，让手环进入到拍照模式，手环上出现拍照按钮，
 *      按键或点击按钮手环SDK会通过 notifyToTakePicture 通知App拍照。
 * 注意: setKeyNotify 进入App智拍模式后设置1. 退出拍照界面设置0
 *      需要做拍照保护，拍照在未保存完成前不要开启第二次拍照。
 */
- (void)notifyToTakePicture{
    [self allDelegates:^(NSObject<BraceletManager> *delegate) {
        if ([delegate respondsToSelector:@selector(braceletDidTakePicture)]) {
            [delegate braceletDidTakePicture];
        }
    }];
    AXCachedLogOBJ(@"notifyToTakePicture");
    showMessage(@"点击了拍照", 5);
}

/*!
 * 描述: 长按手环按钮或者点击触屏选择找手机按钮，手环SDK会通过 notifyToSearchPhone告诉App，手环需要找手机。
 *       接下来App可以播放寻找手机的音乐或者其他操作
 */
- (void)notifyToSearchPhone{
    AXCachedLogOBJ(@"notifyToSearchPhone");
    showAlert(@"正在寻找手机...");
    AudioServicesPlayAlertSound(1008);
}

#pragma mark - ble delegate -> device Info

- (void)updateDeviceInfo:(ZeronerDeviceInfo *)deviceInfo{
    _currentDeviceInfo = deviceInfo;
    NSString *bat = [NSUserDefaults ax_readStringForKey:deviceInfo.seriesNo.extension(@"deviceInfo.batLevel")];
    [_currentDeviceInfo updateBattery:bat];
    [self allDelegates:^(NSObject<BraceletManager> *delegate) {
        if ([delegate respondsToSelector:@selector(braceletDidUpdateDeviceInfo:)]) {
            [delegate braceletDidUpdateDeviceInfo:deviceInfo];
        }
    }];
    AXCachedLogOBJ(deviceInfo);
    NSString *msg = [NSString stringWithFormat:@"获取到设备信息：%@", deviceInfo];
    msg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    showMessage(msg, 10);
    [self.bleSDK readFirmwareOption];
}
- (void)updateBattery:(ZeronerDeviceInfo *)deviceInfo{
    _currentDeviceInfo = deviceInfo;
    [self allDelegates:^(NSObject<BraceletManager> *delegate) {
        if ([delegate respondsToSelector:@selector(braceletDidUpdateDeviceInfo:)]) {
            [delegate braceletDidUpdateDeviceInfo:deviceInfo];
        }
    }];
    AXCachedLogOBJ(deviceInfo);
    [NSUserDefaults ax_setInteger:deviceInfo.batLevel forKey:deviceInfo.seriesNo.extension(@"deviceInfo.batLevel")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        showMessage([NSString stringWithFormat:@"获取到设备电量信息：%ld%%", deviceInfo.batLevel], 5);
    });
}

/**
 the method be called after call - (void)getSupportSportsList;
 
 @param ssList ssList
 */
- (void)notifySupportSportsList:(NSDictionary *)ssList{
    AXCachedLogOBJ(ssList);
}

/**
 *  responseOfGetTime
 *
 *  @param date (year month day hour minute second)
 */
- (void)responseOfGetTime:(NSDate *)date{
    AXCachedLogOBJ(date);
}

/**
 the response of get clock
 
 @param clock clock
 */
- (void)responseOfGetClock:(ZeronerClock *)clock{
    AXCachedLogOBJ(clock);
}

/**
 the response of get sedentary
 
 @param sedentarys sedentarys
 */
- (void)responseOfGetSedentary:(NSArray<ZeronerSedentary *>*)sedentarys{
    AXCachedLogOBJ(sedentarys);
}

/**
 the response of get HWOption
 
 @param hwOption hwOption
 */
- (void)responseOfGetHWOption:(ZeronerHWOption *)hwOption{
    _currentDeviceSetting = hwOption;
    AXCachedLogOBJ(hwOption);
}

- (void)responseOfGetSprotTarget:(ZeronerSportTarget *)spModel{
    AXCachedLogOBJ(spModel);
}

- (void)responseOfDNDSetting:(ZeronerDNDModel *)dndModel{
    AXCachedLogOBJ(dndModel);
}

- (void)responseOfPersonalInfo:(ZeronerPersonal *)pModel{
    AXCachedLogOBJ(pModel);
}

- (void)responseOfMotoControl:(NSUInteger)countsOn{
    AXCachedLogOBJ(@(countsOn));
}

- (void)responseOfCustomOption:(ZeronerCOption *)cOption{
    AXCachedLogOBJ(cOption);
}

- (void)responseOfGPSPoint:(ZeronerGPSPoint *)pModel{
    AXCachedLogOBJ(pModel);
}

#pragma mark - ble delegate -> device data


/**
 *  Method would be invoked when syscData state changed
 *
 *  @param ksdState type means sysc finished process.
 */
- (void)syscDataFinishedStateChange:(KSyscDataState)ksdState{
    NSString *log = [NSString stringWithFormat:@"=============== syscDataFinishedStateChange:%d ===============",ksdState];
    AXCachedLogOBJ(log);
}

/**
 *  Method would be invoked when received sport segement data.（data type is 0x28）
 *
 @param dict dict
 */
- (void)updateSleepData:(NSDictionary *)dict{
    AXCachedLogData(dict);
}

/**
 * Method would be invoked when received sport segement data .（data type is 0x28）
 
 @param dict dict
 */
- (void)updateSportData:(NSDictionary *)dict{
    AXCachedLogData(dict);
}

/**
 *  Method would be invoked when received sport summary data（type 0x29）
 *
 @param dict ：Dictionary object contains accurate timestamp provided by smartband.
 */
- (void)updateWholeDaySportData:(NSDictionary *)dict{
    AXCachedLogData(dict);
}

/**
 *  Method would be invoked when received sport summary data（type 0x29）
 *
 @param dict ：Dictionary object without accurate timestamp provided by smartband. SDK use [NSDate date] replace it.
 */
- (void)updateCurrentWholeDaySportData:(NSDictionary *)dict{
    AXCachedLogData(dict);
}

/**
 * Method would be invoked when received heart rate segement data（type 0x51）
 
 @param dict dict[detail_data], @{type,开始时间，结束时间，消耗能量，5个心率区间的时间分段、能量消耗、平均心率值},]
 */
- (void)updateHeartRateData:(NSDictionary *)dict{
    AXCachedLogData(dict);
}

/**
 *  Method would be invoked when received HeartRate_hours data (type 0x53).
 *  This type data shows data of heart rate in different minutes. In normal, it places one piece of data each hour, each data contains 60 values for average data of heart rate.The API/command for getting this data is @{getHeartRateDataOfHours}, call back method @{@link - (void)updateHeartRateData_hours:(NSDictionary *)dict;}
 *
 * dict[@"hour"] 小时，12表示detail的数据属于 12:00-13:00
 * dict[@"detail_data"], 一个小时内@[每分钟平均心率值]
 */
- (void)updateHeartRateData_hours:(NSDictionary *)dict{
    AXCachedLogData(dict);
}

/**
 * Method invoke by of 0x08.
 * Contain data @{key:{jsonStr}}; type key lists : 0x29\0x28,0x51,0x53;
 * jsonStr equal = @"{\"total\":%d,\"start\":%d,\"end\":%d}"; total =cicle num of seq, start=start of seq; end =end of seq
 */
- (void)updateNormalHealthData:(NSDictionary *)dict{
    AXCachedLogData(dict);
}


#pragma mark -GNSS
//- (void)responseOfHealth60Data:(NSDictionary *)dict;
//- (void)responseOfHealth61IndexTable:(NSDictionary *)dict;
//- (void)responseOfHealth61Data:(NSDictionary *)dict;
//- (void)responseOfGNSS62IndexTable:(NSDictionary *)dict;
//- (void)responseOfGNSS62Data:(NSDictionary *)dict;
//- (void)responseOfGNSS63Data:(NSDictionary *)dict;
//- (void)responseOfECGIndexTable:(NSDictionary *)dict;
//- (void)responseOfECGData:(NSDictionary *)dict;
/**
 *
 *
 */
- (void)allHealthDataDidUploadSport{
    AXCachedLogOBJ(@"");
}
- (void)allHealthDataDidUpload28{
    AXCachedLogOBJ(@"");
}
- (void)allHealthDataDidUploadHeartRate{
    AXCachedLogOBJ(@"");
}
- (void)allHealthDataDidUploadHeartRateHours{
    AXCachedLogOBJ(@"");
}

/**
 *  设置日程的应答
 *
 *  @param success YES 成功  NO 失败
 */
- (void)responseOfScheduleSetting:(BOOL)success{
    NSString *log = [NSString stringWithFormat:@"设置日程的应答:%d",success];
    AXCachedLogOBJ(log);
}

/**
 *  读取某个日程的应答
 *
 *  @param exist YES 存在   NO 不存在
 */
- (void)responseOfScheduleGetting:(BOOL)exist{
    NSString *log = [NSString stringWithFormat:@"读取某个日程的应答:%d",exist];
    AXCachedLogOBJ(log);
}

/**
 *  读取日程Info的应答
 *
 *  @param dict
 dict[@"cur_num"] 当前可配置日程数量
 remaining number of schedule could be set.
 dict[@"all_num"]:日程最大数量
 max number of schedule we can configure
 dict[@"day_num"]:每天可配置日程数量
 max number of schedule could  be configured for one day.
 */
- (void)responseOfScheduleInfoGetting:(NSDictionary *)dict{
    AXCachedLogData(dict);
    
}

- (void)responseSplecialListsInfo:(NSDictionary *)dict{
    AXCachedLogData(dict);
    
}
- (void)responseSplecialRoll:(ZeronerRoll *)zRoll{
    AXCachedLogOBJ(zRoll);
    
}



#pragma mark - system cb delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}



@end
