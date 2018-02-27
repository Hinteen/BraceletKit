//
//  BKSportQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSportQuery.h"
#import "_BKHeader.h"
#import "BKDayData.h"
#import "BKSportData.h"

@implementation BKSportQuery

- (instancetype)init{
    if (self = [super init]) {
        self.steps = @0;
        self.distance = @0;
        self.calorie = @0;
        self.activity = @0;
        self.items = [NSArray array];
        self.hourSteps = [NSMutableArray arrayWithCapacity:24];
        self.hourDistance = [NSMutableArray arrayWithCapacity:24];
        self.hourCalorie = [NSMutableArray arrayWithCapacity:24];
        for (int i = 0; i < 24; i++) {
            [self.hourSteps addObject:@0];
            [self.hourDistance addObject:@0];
            [self.hourCalorie addObject:@0];
        }
    }
    return self;
}

- (void)calcDaySport:(BKSportData *)sport{
    NSInteger startHour = sport.start.stringValue(@"HH").integerValue;
    NSInteger endHour = sport.end.stringValue(@"HH").integerValue;
    if (startHour == endHour) {
        self.hourSteps[startHour] = @(sport.steps);
        self.hourDistance[startHour] = @(sport.distance);
        self.hourCalorie[startHour] = @(sport.calorie);
    } else if (startHour < endHour) {
        CGFloat totalMinutes = (sport.end.timeIntervalSince1970 - sport.start.timeIntervalSince1970) / 60.0;
        for (int i = 0; i <= endHour - startHour; i++) {
            CGFloat minute;
            CGFloat ratio;
            if (i == 0) {
                minute = (CGFloat)sport.start.stringValue(@"mm").integerValue;
                ratio = (60-minute) / totalMinutes;
            } else if (i == endHour - startHour) {
                minute = (CGFloat)sport.end.stringValue(@"mm").integerValue;
                ratio = (minute) / totalMinutes;
            } else {
                ratio = 60.0 / totalMinutes;
            }
            self.hourSteps[startHour + i] =  @(self.hourSteps[startHour + i].integerValue +sport.steps * ratio);
            self.hourDistance[startHour + i] =  @(self.hourDistance[startHour + i].integerValue +sport.distance * ratio);
            self.hourCalorie[startHour + i] =  @(self.hourCalorie[startHour + i].integerValue +sport.calorie * ratio);
        }
    }
}

+ (NSArray<BKQuery *> *)querySummaryWithDate:(NSDate *)date unit:(BKQueryUnit)unit{
    NSMutableArray<BKSportQuery *> *results = [NSMutableArray arrayWithCapacity:unit];
    [self getAlldateWithDate:date unit:unit completion:^(NSDate * _Nonnull date) {
        BKSportQuery *result = [[self alloc] init];
        BKDayData *day = [BKDayData selectWithDate:date unit:BKQueryUnitDaily].lastObject;
        if (day) {
            result.date = [NSDate ax_dateWithIntegerValue:day.dateInteger];
            result.steps = @(day.steps);
            result.distance = @(day.distance);
            result.calorie = @(day.calorie);
            result.activity = @(day.activity);
        }
        NSArray<BKSportData *> *sports = [BKSportData selectWithDate:date unit:BKQueryUnitDaily];
        result.items = sports;
        [results addObject:result];
    }];
    
    // 如果是一天的查询，还需要查询每小时的运动数据
    if (unit == BKQueryUnitDaily) {
        [results.lastObject.items enumerateObjectsUsingBlock:^(BKSportData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [results.lastObject calcDaySport:obj];
        }];
    }
    return results;
}


@end
