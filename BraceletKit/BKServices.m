//
//  BKServices.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKServices.h"

static BKServices *bkServices = nil;

@interface BKServices() <BKConnectDelegate>

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
    self.connectDelegates = [NSMutableArray array];
    // @xaoxuu: delegate
    self.connect = [[BKConnect alloc] initWithDelegate:self];
    
    return self;
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
- (void)allConnectDelegates:(void (^)(NSObject<BKConnectDelegate> *delegate))handler{
    [self.connectDelegates enumerateObjectsUsingBlock:^(NSObject<BKConnectDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (handler) {
            handler(obj);
        }
    }];
}



#pragma mark - 广播 connect delegate

- (void)bkDiscoverDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        [delegate bkDiscoverDevice:device];
    }];
}

- (void)bkConnectedDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        [delegate bkConnectedDevice:device];
    }];
}

- (void)bkUnconnectedDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        [delegate bkUnconnectedDevice:device];
    }];
}

- (void)bkFailToConnectDevice:(BKDevice *)device{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        [delegate bkFailToConnectDevice:device];
    }];
}

- (void)bkConnectTimeout{
    [self allConnectDelegates:^(NSObject<BKConnectDelegate> *delegate) {
        [delegate bkConnectTimeout];
    }];
}


@end
