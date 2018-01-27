//
//  BKQuery.h
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKDefines.h"

NS_ASSUME_NONNULL_BEGIN
@class BKDayData, BKSportData, BKHeartRateData, BKHeartRateHourData, BKSleepData;

/**
 只能查询当前登录用户的当前连接的设备的数据
 */
@interface BKQuery : NSObject

/**
 date
 */
@property (strong, nonatomic) NSDate *date;

#pragma mark - 运动


/**
 查询某一天/一周/一个月/一年的统计数据
 
 unit = daily    查询某一天的摘要数据
 unit = weekly   查询date所在的一整周的统计数据
 unit = monthly  查询date所在的一整月的统计数据
 unit = yearly   查询date所在的一整年的统计数据
 @param date 天（只需要精确到天）
 @param unit 查询单位
 @return 满足条件的统计数据（某一天/一周/一个月/一年）
 */
+ (nullable NSArray<__kindof BKQuery *> *)querySummaryWithDate:(NSDate *)date unit:(BKQueryUnit)unit;


+ (void)getAlldateWithDate:(NSDate *)date unit:(BKQueryUnit)unit completion:(void (^)(NSDate *date))completion;

///**
// 查询某一天的摘要数据
//
// @param date 天（只需要精确到天）
// @return 一天的摘要数据
// */
//+ (nullable NSArray<__kindof BKQuery *> *)queryDailySummaryWithDate:(NSDate *)date;
//
///**
// 查询date所在的一整周的统计数据
//
// @param date 天（只需要精确到天）
// @return 一整周的统计数据
// */
//+ (nullable NSArray<__kindof BKQuery *> *)queryWeeklySummaryWithDate:(NSDate *)date;
//
///**
// 查询date所在的一整月的统计数据
//
// @param date 天（只需要精确到天）
// @return 一整月的统计数据
// */
//+ (nullable NSArray<__kindof BKQuery *> *)queryMonthlySummaryWithDate:(NSDate *)date;
//
///**
// 查询date所在的一整年的统计数据
//
// @param date 天（只需要精确到天）
// @return 一整年的统计数据
// */
//+ (nullable NSArray<__kindof BKQuery *> *)queryYearlySummaryWithDate:(NSDate *)date;




@end
NS_ASSUME_NONNULL_END
