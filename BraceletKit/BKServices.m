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
#import <CoreBluetooth/CoreBluetooth.h>
#import "_BKHeader.h"

static BKServices *bkServices = nil;
static BOOL loadFinished = NO;

@interface BKServices()


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
    _scanner = [[BKScanner alloc] init];
    _connector = [[BKConnector alloc] init];
    _session = [[BKSession alloc] init];
    
    
//     // 初始化数据库所有表
//    NSArray<Class> *arr = NSClassGetAllSubclasses([BKData class]);
//    [arr enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj respondsToSelector:@selector(createTableIfNotExists)]) {
//            [obj createTableIfNotExists];
//        }
//    }];
    loadFinished = YES;
//    [self allServicesDelegates:^(NSObject<BKServicesDelegate> *delegate) {
//        if ([delegate respondsToSelector:@selector(servicesDidLoadFinished:)]) {
//            [delegate servicesDidLoadFinished:self];
//        }
//    }];

    
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


//- (void)registerServicesDelegate:(NSObject<BKServicesDelegate> *)delegate{
//    if (delegate && ![self.servicesDelegates containsObject:delegate]) {
//        [self.servicesDelegates addObject:delegate];
//        if (loadFinished && [delegate respondsToSelector:@selector(servicesDidLoadFinished:)]) {
//            [delegate servicesDidLoadFinished:self];
//        }
//    }
//}
//
//- (void)unRegisterServicesDelegate:(NSObject<BKServicesDelegate> *)delegate{
//    if (delegate && [self.servicesDelegates containsObject:delegate]) {
//        [self.servicesDelegates removeObject:delegate];
//    }
//}
//
//
//
//// @xaoxuu: 让所有的代理执行
//- (void)allServicesDelegates:(void (^)(NSObject<BKServicesDelegate> *delegate))handler{
//    [self.servicesDelegates enumerateObjectsUsingBlock:^(NSObject<BKServicesDelegate> *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (handler) {
//            handler(obj);
//        }
//    }];
//}


@end
