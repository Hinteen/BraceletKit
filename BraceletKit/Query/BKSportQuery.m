//
//  BKSportQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSportQuery.h"
#import "_BKHeader.h"
#import "BKDataDay.h"
#import "BKDataSport.h"

@implementation BKSportQuery

- (instancetype)init{
    if (self = [super init]) {
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


- (instancetype)initWithDayData:(BKDataDay *)day sports:(NSArray<BKDataSport *> *)sports{
    if (self = [self init]) {
        self.date = [NSDate ax_dateWithIntegerValue:day.dateInteger];
        self.steps = day.steps;
        self.distance = day.distance;
        self.calorie = day.calorie;
        self.activity = day.activity;
        // 把运动按小时拆分
        [sports enumerateObjectsUsingBlock:^(BKDataSport * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger startHour = obj.start.stringValue(@"HH").integerValue;
            NSInteger endHour = obj.end.stringValue(@"HH").integerValue;
            if (startHour == endHour) {
                self.hourSteps[startHour] = @(obj.steps);
                self.hourDistance[startHour] = @(obj.distance);
                self.hourCalorie[startHour] = @(obj.calorie);
            } else if (startHour < endHour) {
                CGFloat totalMinutes = (obj.end.timeIntervalSince1970 - obj.start.timeIntervalSince1970) / 60.0;
                for (int i = 0; i <= endHour - startHour; i++) {
                    CGFloat minute;
                    CGFloat ratio;
                    if (i == 0) {
                        minute = (CGFloat)obj.start.stringValue(@"mm").integerValue;
                        ratio = (60-minute) / totalMinutes;
                    } else if (i == endHour - startHour) {
                        minute = (CGFloat)obj.end.stringValue(@"mm").integerValue;
                        ratio = (minute) / totalMinutes;
                    } else {
                        ratio = 60.0 / totalMinutes;
                    }
                    self.hourSteps[startHour + i] =  @(self.hourSteps[startHour + i].integerValue +obj.steps * ratio);
                    self.hourDistance[startHour + i] =  @(self.hourDistance[startHour + i].integerValue +obj.distance * ratio);
                    self.hourCalorie[startHour + i] =  @(self.hourCalorie[startHour + i].integerValue +obj.calorie * ratio);
                }
            }
        }];
    }
    return self;
}

+ (NSArray<BKQuery *> *)querySummaryWithDate:(NSDate *)date unit:(BKQueryUnit)unit{
    // 获取天摘要数据
    BKDataDay *day = [BKDataDay selectFromDatabaseWithDate:date].lastObject;
    // 获取区间内所有运动
    NSArray<BKDataSport *> *sports = [BKDataSport selectFromDatabaseWithDate:date];
    BKSportQuery *result = [[self alloc] initWithDayData:day sports:sports];
#warning 具体到哪一天
    result.date = date;
    result.unit = unit;
    return @[result];
}


@end
