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

+ (nullable __kindof BKQuery *)queryDailySummaryWithDate:(NSDate *)date;

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
//+ (nullable NSArray<__kindof BKQuery *> *)querySummaryWithDate:(NSDate *)date unit:(BKQueryUnit)unit;
/**
 查询某一天/一周/一个月/一年的统计数据
 
 unit = daily      查询某一天的摘要数据
 unit = weekly     查询date所在的一整周的统计数据
 unit = monthly    查询date所在的一整月的统计数据
 unit = yearly     查询date所在的一整年的统计数据
 @param date       日期
 @param selectionUnit 查询单位
 @param viewUnit   预览单位
 @return 满足条件的统计数据（某一天/一周/一个月/一年）
 */
//+ (nullable NSArray<__kindof BKQuery *> *)querySummaryWithDate:(NSDate *)date selectionUnit:(BKQuerySelectionUnit)selectionUnit viewUnit:(BKQueryViewUnit)viewUnit;
+ (nullable NSArray<__kindof BKQuery *> *)querySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit;


//+ (void)getAlldateWithDate:(NSDate *)date unit:(BKQueryUnit)unit completion:(void (^)(NSDate *date))completion;


+ (void)getQueryItemWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit completion:(void (^)(NSDate * start, NSDate * end))completion;
//+ (void)getQueryItemWithDate:(NSDate *)date selectionUnit:(BKQuerySelectionUnit)selectionUnit viewUnit:(BKQueryViewUnit)viewUnit completion:(void (^)(NSDate * start, NSDate * end))completion;

@end
NS_ASSUME_NONNULL_END
