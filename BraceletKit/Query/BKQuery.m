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


+ (nullable NSArray<__kindof BKQuery *> *)queryDaySummaryWithDate:(NSDate *)date{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}


+ (nullable NSArray<__kindof BKQuery *> *)queryDaySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

+ (NSArray<BKQuery *> *)querySummaryWithDate:(NSDate *)date unit:(BKQueryUnit)unit{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

+ (void)getAlldateWithDate:(NSDate *)date unit:(BKQueryUnit)unit completion:(void (^)(NSDate * _Nonnull))completion{
    if (completion) {
        if (unit == BKQueryUnitDaily) {
            completion(date);
        } else if (unit == BKQueryUnitWeekly) {
            NSInteger weekday = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday]; // 1~7
            NSDate *start = date.addDays(1-weekday);
            for (int i = 0; i < 7; i++) {
                completion(start.addDays(i));
            }
        } else if (unit == BKQueryUnitMonthly) {
            int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
            int month = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month]; // 1~12
            NSDate *start = [NSDate ax_dateWithIntegerValue:[NSString stringWithFormat:@"%04d%02d00", year, month].integerValue];
            NSDate *target = start;
            while ([[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:target] month] == [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month]) {
                completion(target);
                target = target.addDays(1);
            }
        } else if (unit == BKQueryUnitYearly) {
            int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
            NSDate *start = [NSDate ax_dateWithIntegerValue:[NSString stringWithFormat:@"%04d0000", year].integerValue];
            NSDate *target = start;
            while ([[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:target] year] == [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year]) {
                completion(target);
                target = target.addDays(1);
            }
        }
    }
}

@end
