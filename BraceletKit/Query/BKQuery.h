//
//  BKQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BKDataDay, BKDataSport, BKDataHR, BKDataHRHour, BKDataSleep;

/**
 只能查询当前登录用户的当前连接的设备的数据
 */
@interface BKQuery : NSObject


/**
 时间
 */
@property (strong, nonatomic) NSDate *date;



#pragma mark - 运动

/**
 查询一天的摘要数据（步数、距离、卡路里、活动时长）

 @param date 天
 @return 摘要数据（步数、距离、卡路里、活动时长）
 */
+ (nullable instancetype)queryDaySummaryWithDate:(NSDate *)date;

/**
 查询若干天的摘要数据（每天的步数、距离、卡路里、活动时长）

 @param startDate 开始日期
 @param endDate 结束日期
 @return 每一天的摘要数据（每天的步数、距离、卡路里、活动时长）
 */
+ (nullable NSArray<BKQuery *> *)queryDaySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;


/**
 查询一天的运动详情（分段运动）

 @param date 天
 @return 运动详情（分段运动）
 */
+ (NSArray<BKDataSport *> *)queryDaySportsWithDate:(NSDate *)date;



#pragma mark - 心率

/**
 查询一天的心率摘要数据

 @param date 天
 @return 心率摘要数据
 */
+ (NSArray<BKDataHR *> *)queryHeartRateSummaryWithDate:(NSDate *)date;

/**
 查询一天的心率详情数据（小时心率）

 @param date 天
 @return 心率详情数据（小时心率）
 */
+ (NSArray<BKDataHRHour *> *)queryHeartRateDetailWithDate:(NSDate *)date;



#pragma mark - 睡眠

/**
 查询一天的睡眠数据

 @param date 天
 @return 睡眠数据
 */
+ (NSArray<BKDataSleep *> *)querySleepDetailWithDate:(NSDate *)date;



@end
NS_ASSUME_NONNULL_END
