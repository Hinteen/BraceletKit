//
//  Foundation+AXLogExtension.h
//  AXKit
//
//  Created by xaoxuu on 05/03/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifdef __OBJC__ // ==================== [ __OBJC__ Macro ] ==================== //
#ifdef DEBUG // ==================== [ DEBUG Macro ] ==================== //

// ======== ======== 调试类 ======== ========
// NSLog
#define AXLogFormat(format, ...) NSLog((@"\n➤ func:%s " "line:%d" "\n💬" format "\n\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__)
// 当前function和line
#define AXLogFunc() NSLog((@"\n➤ func:%s " "line:%d" "\n\n"), __FUNCTION__, __LINE__)


// ======== ======== 结果类 ======== ========
// bool值
#define AXLogBOOL(BOOL) NSLog((@"\n➤ func:%s " "line:%d" "\n%@" "\n\n"), __FUNCTION__, __LINE__, BOOL ? @"🔵true" : @"🔴false")
// 成功信息
#define AXLogSuccess(format, ...) NSLog((@"\n➤ func:%s " "line:%d" "\n🔵success: " format "\n\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__)
// 警告信息
#define AXLogWarning(format, ...) NSLog((@"\n➤ func:%s" " line:%d" "\n⚠️warning: " format "\n\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__)
// 失败信息
#define AXLogFailure(format, ...) NSLog((@"\n➤ func:%s " "line:%d" "\n🔴error: " format "\n\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__)
// error详情
#define AXLogError(NSError) NSLog((@"\n➤ func:%s " "line:%d" "\n🔴error: \n%@" "\n\n"), __FUNCTION__, __LINE__, NSError.description)


// ======== ======== 对象和指针 ======== ========
// 对象
#define AXLogOBJ(NSObject) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%@" "\n\n"), __FUNCTION__, __LINE__, NSObject)
// 指针
#define AXLogPointer(id) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%p" "\n\n"), __FUNCTION__, __LINE__, id)


// ======== ======== 基本数据类型 ======== ========
// int类型
#define AXLogInt(int) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%@" "\n\n"), __FUNCTION__, __LINE__, @(int))
// NSInteger类型
#define AXLogNSInteger(NSInteger) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%@" "\n\n"), __FUNCTION__, __LINE__, @(NSInteger))
// NSUInteger类型
#define AXLogNSUInteger(NSUInteger) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%@" "\n\n"), __FUNCTION__, __LINE__, @(NSUInteger))

// float类型
#define AXLogFloat(float) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%@" "\n\n"), __FUNCTION__, __LINE__, @(float))
// double类型
#define AXLogDouble(double) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%@" "\n\n"), __FUNCTION__, __LINE__, @(double))
// CGFloat类型
#define AXLogCGFloat(CGFloat) NSLog((@"\n➤ func:%s " "line:%d" "\n💬%@" "\n\n"), __FUNCTION__, __LINE__, @(CGFloat))


// ======== ======== 结构体 ======== ========
// CGPoint类型
#define AXLogCGPoint(CGPoint) NSLog((@"\n➤ func:%s " "line:%d" "\n💬CGPoint: %@" "\n\n"), __FUNCTION__, __LINE__, NSStringFromCGPoint(CGPoint))
// CGSize类型
#define AXLogCGSize(CGSize) NSLog((@"\n➤ func:%s " "line:%d" "\n💬CGSize: %@" "\n\n"), __FUNCTION__, __LINE__, NSStringFromCGSize(CGSize))
// CGRect类型
#define AXLogCGRect(CGRect) NSLog((@"\n➤ func:%s " "line:%d" "\n💬CGRect: %@" "\n\n"), __FUNCTION__, __LINE__, NSStringFromCGRect(CGRect))


#else

// ======== ======== 调试类 ======== ========
#define AXLogFormat(format, ...)
#define AXLogFunc()
// ======== ======== 结果类 ======== ========
// result macro
#define AXLogBOOL(BOOL)
#define AXLogSuccess(format, ...)
#define AXLogWarning(format, ...)
#define AXLogFailure(format, ...)
#define AXLogError(NSError)
// ======== ======== 对象和指针 ======== ========
// obj macro
#define AXLogOBJ(NSObject)
#define AXLogPointer(id)
// ======== ======== 基本数据类型 ======== ========
// CG macro
#define AXLogInt(int)
#define AXLogNSInteger(NSInteger)
#define AXLogNSUInteger(NSUInteger)

#define AXLogFloat(float)
#define AXLogDouble(double)
#define AXLogCGFloat(CGFloat)
// ======== ======== 结构体 ======== ========
#define AXLogCGPoint(CGPoint)
#define AXLogCGSize(CGSize)
#define AXLogCGRect(CGRect)


#endif // ==================== [ DEBUG Macro ] ==================== //



#else
#endif // ==================== [ __OBJC__ Macro ] ==================== //


#define AXLogToCachePath(NSObject) [AXLog writeLogWithFunc:[NSString stringWithFormat:@"%s", __FUNCTION__] input:NSObject]


NS_ASSUME_NONNULL_BEGIN
@interface AXLog : NSObject


/**
 配置log文件版本

 @param version log文件版本
 */
+ (void)configLogVersion:(CGFloat)version;

/**
 获取所有的日志路径

 @return 日志路径
 */
+ (nullable NSArray<NSString *> *)getAllCachedLogPath;

/**
 获取某个日期以后的日志路径

 @param date 日期
 @return 日志路径
 */
+ (nullable NSArray<NSString *> *)getLatestCachedLogPathSinceDate:(NSDate *)date;


/**
 获取最近几条日志路径

 @param count 日志数量
 @return 日志路径
 */
+ (nullable NSArray<NSString *> *)getLatestCachedLogPathWithCount:(NSUInteger)count;

/**
 根据路径读取某个日志内容

 @param path 日志路径
 @return 日志内容
 */
+ (nullable NSString *)getLogStringWithPath:(NSString *)path;

/**
 写日志（每次启动保存一份日志文件，文件名为启动时间）
 要在日志中记录更详细的内容，需要重写输入对象的-description方法。

 @param func __FUNCTION__
 @param input 输入obj
 */
+ (void)writeLogWithFunc:(NSString *)func input:(NSObject *)input;

@end
NS_ASSUME_NONNULL_END
