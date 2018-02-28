//
//  BKServices.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKServices.h"
#import "_BKDatabaseHelper.h"
#import <AXKit/AXKit.h>

static BKServices *bkServices = nil;
static BOOL loadFinished = NO;

@interface BKServices() <BKScanDelegate, BKConnectDelegate, BKDeviceDelegate>

@property (strong, nonatomic) NSMutableArray<NSObject<BKServicesDelegate> *> *servicesDelegates;

@property (strong, nonatomic) NSMutableArray<NSObject<BKScanDelegate> *> *scanDelegates;

@property (strong, nonatomic) NSMutableArray<NSObject<BKConnectDelegate> *> *connectDelegates;

@property (strong, nonatomic) NSMutableArray<NSObject<BKDeviceDelegate> *> *deviceDelegates;

@property (strong, nonatomic) NSMutableArray<NSObject<BKDataObserver> *> *dataObservers;


@end

@implementation BKServices


#pragma mark - life circle


+ (instancetype)defaultManager{
    return [self sharedInstance];
}

+ (instancetype)sharedInstance{
    if (!bkServices) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            bkServices = [[self alloc] init];
        });
    }
    return bkServices;
}

#pragma mark init

- (instancetype)init{
    if (self = [super init]) {
        
    }
    self.servicesDelegates = [NSMutableArray array];
    self.scanDelegates = [NSMutableArray array];
    self.connectDelegates = [NSMutableArray array];
    self.deviceDelegates = [NSMutableArray array];
    self.dataObservers = [NSMutableArray array];
    // @xaoxuu: delegate
    _scanner = [[BKScanner alloc] initWithDelegate:self];
    _connector = [[BKConnector alloc] initWithDelegate:self];
    
    // 初始化数据库所有表
    NSArray<Class> *arr = NSClassGetAllSubclasses([BKData class]);
    [arr enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(createTableIfNotExists)]) {
            [obj createTableIfNotExists];
        }
    }];
    loadFinished = YES;
    [self allServicesDelegates:^(NSObject<BKServicesDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(servicesDidLoadFinished:)]) {
            [delegate servicesDidLoadFinished:self];
        }
    }];

    
    return self;
}




- (BOOL)registerServiceWithUser:(BKUser *)user{
    if (user.email.length) {
        _user = user;
        return YES;
    } else {
        return NO;
    }
}


- (void)registerServicesDelegate:(NSObject<BKServicesDelegate> *)delegate{
    if (delegate && ![self.servicesDelegates containsObject:delegate]) {
        [self.servicesDelegates addObject:delegate];
        if (loadFinished && [delegate respondsToSelector:@selector(servicesDidLoadFinished:)]) {
            [delegate servicesDidLoadFinished:self];
        }
    }
}

- (void)unRegisterServicesDelegate:(NSObject<BKServicesDelegate> *)delegate{
    if (delegate && [self.servicesDelegates containsObject:delegate]) {
        [self.servicesDelegates removeObject:delegate];
    }
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


- (void)registerConnectDelegate:(NSObject<BKConnectDelegate> *)delegate{
    if (delegate && ![self.connectDelegates containsObject:delegate]) {
        [self.connectDelegates addObject:delegate];
    }
}

- (void)unRegisterConnectDelegate:(NSObject<BKConnectDelegate> *)delegate{
    if (delegate && [self.connectDelegates containsObject:delegate]) {
        [self.connectDelegates removeObject:delegate];
    }
}

- (void)registerDeviceDelegate:(NSObject<BKDeviceDelegate> *)delegate{
    if (delegate && ![self.deviceDelegates containsObject:delegate]) {
        [self.deviceDelegates addObject:delegate];
    }
}

- (void)unRegisterDeviceDelegate:(NSObject<BKDeviceDelegate> *)delegate{
    if (delegate && [self.deviceDelegates containsObject:delegate]) {
        [self.deviceDelegates removeObject:delegate];
    }
}

- (void)registerDataObserver:(NSObject<BKDataObserver> *)observer{
    if (observer && ![self.dataObservers containsObject:observer]) {
        [self.dataObservers addObject:observer];
    }
}

- (void)unRegisterDataObserver:(NSObject<BKDataObserver> *)observer{
    if (observer && [self.dataObservers containsObject:observer]) {
        [self.dataObservers removeObject:observer];
    }
}



// @xaoxuu: 让所有的代理执行
- (void)allServicesDelegates:(void (^)(NSObject<BKServicesDelegate> *delegate))handler{
    [self.servicesDelegates enumerateObjectsUsingBlock:^(NSObject<BKServicesDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}

- (void)allScannerDelegates:(void (^)(NSObject<BKScanDelegate> *delegate))handler{
    [self.scanDelegates enumerateObjectsUsingBlock:^(NSObject<BKScanDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}
- (void)allConnectDelegates:(void (^)(NSObject<BKConnectDelegate> *delegate))handler{
    [self.connectDelegates enumerateObjectsUsingBlock:^(NSObject<BKConnectDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}
- (void)allDeviceDelegates:(void (^)(NSObject<BKDeviceDelegate> *delegate))handler{
    [self.deviceDelegates enumerateObjectsUsingBlock:^(NSObject<BKDeviceDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}
- (void)allDataObservers:(void (^)(NSObject<BKDataObserver> *observer))handler{
    [self.dataObservers enumerateObjectsUsingBlock:^(NSObject<BKDataObserver> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}


#pragma mark - scan delegate

- (void)scannerDidDiscoverDevice:(BKDevice *)device{
    [self allScannerDelegates:^(NSObject<BKScanDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(scannerDidDiscoverDevice:)]) {
            [delegate scannerDidDiscoverDevice:device];
        }
    }];
}
- (void)scannerForCentralManagerDidUpdateState:(CBCentralManager *)central{
    [self allScannerDelegates:^(NSObject<BKScanDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(scannerForCentralManagerDidUpdateState:)]) {
            [delegate scannerForCentralManagerDidUpdateState:central];
        }
    }];
}
- (void)scannerForCentralManagerDidDiscoverDevice:(BKDevice *)device{
    [self allScannerDelegates:^(NSObject<BKScanDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(scannerForCentralManagerDidDiscoverDevice:)]) {
            [delegate scannerForCentralManagerDidDiscoverDevice:device];
        }
    }];
}

#pragma mark - connect delegate

- (void)connectorDidConnectedDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidConnectedDevice:)]) {
            [delegate connectorDidConnectedDevice:device];
        }
    }];
}

- (void)connectorDidUnconnectedDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidUnconnectedDevice:)]) {
            [delegate connectorDidUnconnectedDevice:device];
        }
    }];
}

- (void)connectorDidFailToConnectDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidFailToConnectDevice:)]) {
            [delegate connectorDidFailToConnectDevice:device];
        }
    }];
}

- (void)connectorDidConnectTimeout{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(connectorDidConnectTimeout)]) {
            [delegate connectorDidConnectTimeout];
        }
    }];
}



#pragma mark - device delegate

- (void)deviceDidSynchronizing:(BOOL)synchronizing{
    [self allDeviceDelegates:^(NSObject<BKDeviceDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(deviceDidSynchronizing:)]) {
            [delegate deviceDidSynchronizing:synchronizing];
        }
    }];
}

- (void)deviceDidUpdateSynchronizeProgress:(CGFloat)progress{
    [self allDeviceDelegates:^(NSObject<BKDeviceDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(deviceDidUpdateSynchronizeProgress:)]) {
            [delegate deviceDidUpdateSynchronizeProgress:progress];
        }
    }];
}

- (void)deviceDidUpdateInfo{
    [self allDeviceDelegates:^(NSObject<BKDeviceDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(deviceDidUpdateInfo)]) {
            [delegate deviceDidUpdateInfo];
        }
    }];
}

- (void)deviceDidUpdateBattery:(NSInteger)battery{
    [self allDeviceDelegates:^(NSObject<BKDeviceDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(deviceDidUpdateBattery:)]) {
            [delegate deviceDidUpdateBattery:battery];
        }
    }];
}

- (void)deviceDidTappedTakePicture{
    [self allDeviceDelegates:^(NSObject<BKDeviceDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(deviceDidTappedTakePicture)]) {
            [delegate deviceDidTappedTakePicture];
        }
    }];
}

- (void)deviceDidTappedFindMyPhone{
    [self allDeviceDelegates:^(NSObject<BKDeviceDelegate> *delegate) {
        if ([delegate respondsToSelector:@selector(deviceDidTappedFindMyPhone)]) {
            [delegate deviceDidTappedFindMyPhone];
        }
    }];
}



#pragma mark - data delegate

- (void)userDidUpdated:(BKUser *)user{
    [self allDataObservers:^(NSObject<BKDataObserver> *observer) {
        if ([observer respondsToSelector:@selector(userDidUpdated:)]) {
            [observer userDidUpdated:user];
        }
    }];
}
- (void)preferencesDidUpdated:(BKPreferences *)preferences{
    [self allDataObservers:^(NSObject<BKDataObserver> *observer) {
        if ([observer respondsToSelector:@selector(preferencesDidUpdated:)]) {
            [observer preferencesDidUpdated:preferences];
        }
    }];
}
- (void)dataDidUpdated:(__kindof BKData *)data{
    [self allDataObservers:^(NSObject<BKDataObserver> *observer) {
        if ([observer respondsToSelector:@selector(dataDidUpdated:)]) {
            [observer dataDidUpdated:data];
        }
    }];
}

@end
