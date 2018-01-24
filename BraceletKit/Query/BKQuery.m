//
//  BKQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKQuery.h"

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

@end
