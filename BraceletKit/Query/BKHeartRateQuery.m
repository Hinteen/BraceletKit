//
//  BKHeartRateQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKHeartRateQuery.h"
#import "BKDayData.h"
#import "BKHeartRateData.h"
#import "BKHeartRateHourData.h"
#import "_BKHeader.h"

@implementation BKHeartRateQuery

- (instancetype)init{
    if (self = [super init]) {
        self.timeDetail = [NSMutableArray arrayWithCapacity:5];
        self.energyDetail = [NSMutableArray arrayWithCapacity:5];
        self.hrDetail = [NSMutableArray arrayWithCapacity:5];
        self.minuteHR = [NSMutableArray arrayWithCapacity:24*60];
        for (int i = 0; i < 5; i++) {
            [self.timeDetail addObject:@0];
            [self.energyDetail addObject:@0];
            [self.hrDetail addObject:@0];
        }
        for (int i = 0; i < 24*60; i++) {
            [self.minuteHR addObject:@0];
        }
    }
    return self;
}

- (void)calcHeartRateData:(BKHeartRateData *)hrModel{
    for (int i = 0; i < 5; i++) {
//        self.timeDetail[i] = @(self.timeDetail[i].integerValue + hrModel.timeDetail[i].integerValue);
//        self.energyDetail[i] = @(self.energyDetail[i].doubleValue + hrModel.energyDetail[i].doubleValue);
//        self.hrDetail[i] = @(self.hrDetail[i].integerValue + hrModel.hrDetail[i].integerValue);
        self.energy += hrModel.energy;
    }
}

// 必须传入24个小时的每小时心率
//- (instancetype)initWithHeartRateData:(NSArray<BKHeartRateData *> *)hrModels hoursData:(NSArray<BKHeartRateHourData *> *)hourModels{
//    if (self = [self init]) {
//        [hrModels enumerateObjectsUsingBlock:^(BKHeartRateData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            for (int i = 0; i < 5; i++) {
//                self.timeDetail[i] = @(self.timeDetail[i].integerValue + obj.timeDetail[i].integerValue);
//                self.energyDetail[i] = @(self.energyDetail[i].doubleValue + obj.energyDetail[i].doubleValue);
//                self.hrDetail[i] = @(self.hrDetail[i].integerValue + obj.hrDetail[i].integerValue);
//                self.energy += obj.energy;
//            }
//
//        }];
//        [hourModels enumerateObjectsUsingBlock:^(BKHeartRateHourData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [self.minuteDetail addObjectsFromArray:obj.hrDetail];
//        }];
//        // 提取出有效心率，进行数据分析
//        NSMutableArray<NSNumber *> *validHR = [NSMutableArray array];
//        [self.minuteDetail enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.integerValue > 0 && obj.integerValue < 255) {
//                [validHR addObject:obj];
//            }
//        }];
//        self.avgBpm = (NSInteger)[validHR ax_avg];
//        self.maxBpm = (NSInteger)[validHR ax_max];
//        self.minBpm = (NSInteger)[validHR ax_min];
//    }
//    return self;
//}



+ (NSArray<BKQuery *> *)querySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit{
    NSMutableArray<BKHeartRateQuery *> *results = [NSMutableArray array];
    [self getQueryItemWithStartDate:startDate endDate:endDate selectionUnit:selectionUnit completion:^(NSDate * _Nonnull start, NSDate * _Nonnull end) {
        BKHeartRateQuery *result = [[self alloc] init];
        result.date = start;
        NSArray<BKHeartRateData *> *hrModels = [BKHeartRateData selectWithStartDate:start endDate:end];
        NSArray<BKHeartRateHourData *> *hrHourModels = [BKHeartRateHourData selectWithStartDate:start endDate:end];
        [hrModels enumerateObjectsUsingBlock:^(BKHeartRateData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [result calcHeartRateData:obj];
        }];
        if (endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970 <= 24 * 60 * 60 + 1) {
            [hrHourModels enumerateObjectsUsingBlock:^(BKHeartRateHourData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                for (int i = 0; i < 60; i++) {
                    if (obj.hrDetail[i].intValue < 255) {
                        result.minuteHR[obj.hour * 60 + i] = obj.hrDetail[i];
                    } else {
                        result.minuteHR[obj.hour * 60 + i] = @0;
                    }
                    
                }
            }];
        }
        BKDayData *day = [BKDayData selectWithStartDate:start endDate:end].lastObject;
        if (day) {
            result.maxBpm = day.maxBpm;
            result.avgBpm = day.avgBpm;
            result.minBpm = day.minBpm;
        }
        [results addObject:result];
    }];
    return results;
}


@end
