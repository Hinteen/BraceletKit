//
//  BKDailyHRQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDailyHRQuery.h"
#import "BKDataHR.h"
#import "BKDataHRHour.h"
#import "_BKHeader.h"

@implementation BKDailyHRQuery

- (instancetype)init{
    if (self = [super init]) {
        self.energy = 0;
        self.timeDetail = [NSMutableArray arrayWithCapacity:5];
        self.energyDetail = [NSMutableArray arrayWithCapacity:5];
        self.hrDetail = [NSMutableArray arrayWithCapacity:5];
        self.minuteDetail = [NSMutableArray arrayWithCapacity:24*60];
        for (int i = 0; i < 5; i++) {
            [self.timeDetail addObject:@0];
            [self.energyDetail addObject:@0];
            [self.hrDetail addObject:@0];
        }
        for (int i = 0; i < 24*60; i++) {
            [self.minuteDetail addObject:@0];
        }
    }
    return self;
}

// 必须传入24个小时的每小时心率
- (instancetype)initWithHeartRateData:(NSArray<BKDataHR *> *)hrModels hoursData:(NSArray<BKDataHRHour *> *)hourModels{
    if (self = [self init]) {
        [hrModels enumerateObjectsUsingBlock:^(BKDataHR * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (int i = 0; i < 5; i++) {
                self.timeDetail[i] = @(self.timeDetail[i].integerValue + obj.timeDetail[i].integerValue);
                self.energyDetail[i] = @(self.energyDetail[i].doubleValue + obj.energyDetail[i].doubleValue);
                self.hrDetail[i] = @(self.hrDetail[i].integerValue + obj.hrDetail[i].integerValue);
                self.energy += obj.energy;
            }
            
        }];
        [hourModels enumerateObjectsUsingBlock:^(BKDataHRHour * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.minuteDetail addObjectsFromArray:obj.hrDetail];
        }];
        // 提取出有效心率，进行数据分析
        NSMutableArray<NSNumber *> *validHR = [NSMutableArray array];
        [self.minuteDetail enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.integerValue > 0 && obj.integerValue < 255) {
                [validHR addObject:obj];
            }
        }];
        self.avgBpm = (NSInteger)[validHR ax_avg];
        self.maxBpm = (NSInteger)[validHR ax_max];
        self.minBpm = (NSInteger)[validHR ax_min];
    }
    return self;
}


+ (NSArray<BKQuery *> *)querySummaryWithDate:(NSDate *)date{
    NSArray<BKDataHR *> *hrModels = [BKDataHR selectFromDatabaseWithDate:date];
    NSArray<BKDataHRHour *> *hrHourModels = [BKDataHRHour selectFromDatabaseWithDate:date];
    BKDailyHRQuery *result = [[BKDailyHRQuery alloc] initWithHeartRateData:hrModels hoursData:hrHourModels];
    return @[result];
}

@end
