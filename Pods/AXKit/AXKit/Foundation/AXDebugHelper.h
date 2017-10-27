//
//  AXDebugHelper.h
//  AXKit
//
//  Created by xaoxuu on 16/08/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
/**
 只在debug模式下运行的函数
 
 @param debug debug模式下执行的代码
 */
FOUNDATION_EXTERN void ax_debug_only(void (^ _Nullable debug)(void));


/**
 debug和release模式的宏

 @param debug debug模式下执行的代码
 @param release release模式下执行的代码
 */
FOUNDATION_EXTERN void ax_debug_release(void (^ _Nullable debug)(void), void (^ _Nullable release)(void));

/**
 判断当前是不是debug模式
 
 @return YES:debug模式；NO:release模式
 */
FOUNDATION_EXTERN BOOL ax_is_debug(void);

NS_ASSUME_NONNULL_END
