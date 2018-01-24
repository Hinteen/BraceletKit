//
//  BKDayQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDayQuery.h"
#import "BKDataDay.h"
#import "BKDataSport.h"

@implementation BKDayQuery

- (instancetype)init{
    if (self = [super init]) {
        _hourSteps = [NSMutableArray arrayWithCapacity:24];
        _hourDistance = [NSMutableArray arrayWithCapacity:24];
        _hourCalorie = [NSMutableArray arrayWithCapacity:24];
        for (int i = 0; i < 24; i++) {
            [_hourSteps addObject:@0];
            [_hourDistance addObject:@0];
            [_hourCalorie addObject:@0];
        }
    }
    return self;
}

+ (instancetype)queryDaySummaryWithDate:(NSDate *)date{
    BKDataDay *day = [BKDataDay selectFromDatabaseWithDate:date];
    BKDayQuery *result = [[BKDayQuery alloc] init];
    result.steps = day.steps;
    result.distance = day.distance;
    result.calorie = day.calorie;
    result.activity = day.activity;
    NSArray<BKDataSport *> *sports = [BKDataSport selectFromDatabaseWithDate:date];
    [sports enumerateObjectsUsingBlock:^(BKDataSport * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    return result;
}

@end
