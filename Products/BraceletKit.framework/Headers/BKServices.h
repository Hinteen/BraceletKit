//
//  BKServices.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKUser.h"
#import "BKScanner.h"
#import "BKConnector.h"
#import "BKSession.h"

@class BKServices;

@protocol BKServicesDelegate <NSObject>
@optional
/**
 服务加载完毕

 @param services 服务
 */
- (void)servicesDidLoadFinished:(BKServices *)services;

@end

@interface BKServices : NSObject <BKDataObserver>

/**
 用户
 */
@property (strong, readonly, nonatomic) BKUser *user;


/**
 扫描器
 */
@property (strong, readonly, nonatomic) BKScanner *scanner;


/**
 连接器
 */
@property (strong, readonly, nonatomic) BKConnector *connector;

/**
 session
 */
@property (strong, readonly, nonatomic) BKSession *session;


+ (instancetype)sharedInstance;


///**
// 注册服务
//
// @param user 用户
// */
//- (BOOL)registerServiceWithUser:(BKUser *)user;
//
//
///**
// 注册服务代理
//
// @param delegate 代理
// */
//- (void)registerServicesDelegate:(NSObject<BKServicesDelegate> *)delegate;
//
///**
// 取消注册服务代理
//
// @param delegate 代理
// */
//- (void)unRegisterServicesDelegate:(NSObject<BKServicesDelegate> *)delegate;


@end
