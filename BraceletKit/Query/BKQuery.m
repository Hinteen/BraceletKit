//
//  BKQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"
#import <AXKit/AXKit.h>

@implementation BKQuery


+ (nullable __kindof BKQuery *)queryDailySummaryWithDate:(NSDate *)date{
    NSDate *target = [NSDate ax_dateWithIntegerValue:date.integerValue] ?: date;
    return [self querySummaryWithStartDate:target endDate:target.addDays(1) selectionUnit:BKQuerySelectionUnitDaily].firstObject;
}


+ (nullable NSArray<__kindof BKQuery *> *)queryDaySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

+ (nullable NSArray<__kindof BKQuery *> *)querySummaryWithDate:(NSDate *)date selectionUnit:(BKQuerySelectionUnit)selectionUnit viewUnit:(BKQueryViewUnit)viewUnit{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}
+ (nullable NSArray<__kindof BKQuery *> *)querySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

+ (void)getQueryItemWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit completion:(void (^)(NSDate * _Nonnull, NSDate * _Nonnull))completion{
    if (completion) {
        NSDate *from = startDate;
        NSDate *to;
        do {
            if (selectionUnit == BKQuerySelectionUnitDaily) {
                to = from.addDays(1);
            } else if (selectionUnit == BKQuerySelectionUnitWeekly) {
                to = from.addWeeks(1);
            } else if (selectionUnit == BKQuerySelectionUnitMonthly) {
                to = from.addMonths(1);
            } else {
                to = from.addYears(1);
            }
            completion(from, to);
            from = to;
        } while (to.integerValue < endDate.integerValue);
    }
}
+ (void)getQueryItemWithDate:(NSDate *)date selectionUnit:(BKQuerySelectionUnit)selectionUnit viewUnit:(BKQueryViewUnit)viewUnit completion:(void (^)(NSDate * _Nonnull, NSDate * _Nonnull))completion{
    if (completion) {
        if (viewUnit == BKQueryViewUnitDaily) {
            // 天视图
            NSDate *start = [NSDate ax_dateWithIntegerValue:date.integerValue];
            NSDate *end = start.addDays(1);
            if (selectionUnit == BKQuerySelectionUnitDaily) {
                [self getQueryItemWithStartDate:start endDate:end selectionUnit:selectionUnit completion:completion];
            } else {
                NSAssert(NO, @"错误的查询单位");
            }
        } else if (viewUnit == BKQueryViewUnitWeekly) {
            // 周视图
            NSInteger weekday = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday]; // 1~7
            NSDate *start = date.addDays(1-weekday); // 这周的第一天
            NSDate *end = start.addWeeks(1); // 这周的最后一天
            if (selectionUnit == BKQuerySelectionUnitYearly || selectionUnit == BKQuerySelectionUnitMonthly) {
                NSAssert(NO, @"错误的查询单位");
            } else {
                [self getQueryItemWithStartDate:start endDate:end selectionUnit:selectionUnit completion:completion];
            }
        } else if (viewUnit == BKQueryViewUnitMonthly) {
            // 月视图
            int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
            int month = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month]; // 1~12
            NSDate *start = [NSDate ax_dateWithIntegerValue:[NSString stringWithFormat:@"%04d%02d01", year, month].integerValue];
            NSDate *end = start.addMonths(1);
            if (selectionUnit == BKQuerySelectionUnitYearly) {
                NSAssert(NO, @"错误的查询单位");
            } else {
                [self getQueryItemWithStartDate:start endDate:end selectionUnit:selectionUnit completion:completion];
            }
        } else if (viewUnit == BKQueryViewUnitYearly) {
            // 年视图
            int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
            NSDate *start = [NSDate ax_dateWithIntegerValue:[NSString stringWithFormat:@"%04d0101", year].integerValue];
            NSDate *end = start.addYears(1);
            [self getQueryItemWithStartDate:start endDate:end selectionUnit:selectionUnit completion:completion];
        }
    }
}


@end
