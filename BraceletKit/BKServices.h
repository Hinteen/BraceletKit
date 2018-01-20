//
//  BKServices.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKConnect.h"



@interface BKServices : NSObject

/**
 connect manager
 */
@property (strong, nonatomic) BKConnect *connect;




+ (instancetype)sharedInstance;

/**
 注册代理
 
 @param delegate 代理
 */
- (void)registerConnectDelegate:(NSObject<BKConnectDelegate> *)delegate;

/**
 取消注册代理
 
 @param delegate 代理
 */
- (void)unRegisterConnectDelegate:(NSObject<BKConnectDelegate> *)delegate;




@end
