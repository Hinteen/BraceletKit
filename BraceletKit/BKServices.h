//
//  BKServices.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKConnect.h"
#import "BKUser.h"


@interface BKServices : NSObject


/**
 用户
 */
@property (strong, readonly, nonatomic) BKUser *user;

/**
 连接
 */
@property (strong, readonly, nonatomic) BKConnect *connect;




+ (instancetype)sharedInstance;

/**
 注册服务

 @param user 用户
 */
- (BOOL)registerServiceWithUser:(BKUser *)user;


/**
 注册连接代理
 
 @param delegate 代理
 */
- (void)registerConnectDelegate:(NSObject<BKConnectDelegate> *)delegate;

/**
 取消注册连接代理
 
 @param delegate 代理
 */
- (void)unRegisterConnectDelegate:(NSObject<BKConnectDelegate> *)delegate;




@end
