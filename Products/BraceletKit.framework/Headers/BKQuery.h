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

+ (nullable NSArray<__kindof BKQuery *> *)querySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit;


+ (void)getQueryItemWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit completion:(void (^)(NSDate * start, NSDate * end))completion;


@end
NS_ASSUME_NONNULL_END
