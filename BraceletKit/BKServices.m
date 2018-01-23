//
//  BKServices.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKServices.h"

static BKServices *bkServices = nil;

@interface BKServices() <BKScanDelegate, BKConnectDelegate>

@property (strong, nonatomic) NSMutableArray<NSObject<BKScanDelegate> *> *scanDelegates;

@property (strong, nonatomic) NSMutableArray<NSObject<BKConnectDelegate> *> *connectDelegates;

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
    self.scanDelegates = [NSMutableArray array];
    self.connectDelegates = [NSMutableArray array];
    // @xaoxuu: delegate
    _scanner = [[BKScanner alloc] initWithDelegate:self];
    _connector = [[BKConnector alloc] initWithDelegate:self];
    _querier = [[BKDataQuerier alloc] init];
    
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

// @xaoxuu: 让所有的代理执行
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



#pragma mark - 广播 scanner delegate

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

#pragma mark - 广播 connect delegate

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


@end
