//
//  BKSleepQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSleepQuery.h"
#import "BKSleepData.h"

@implementation BKSleepQuery


- (instancetype)init{
    if (self = [super init]) {
        self.items = [NSMutableArray array];
    }
    return self;
}


- (instancetype)initWithSleepData:(NSArray<BKSleepData *> *)sleeps{
    if (self = [self init]) {
        self.items = [NSMutableArray arrayWithArray:sleeps];
    }
    return self;
}

+ (NSArray<BKQuery *> *)querySummaryWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectionUnit:(BKQuerySelectionUnit)selectionUnit{
    NSMutableArray<BKSleepQuery *> *results = [NSMutableArray array];
    [self getQueryItemWithStartDate:startDate endDate:endDate selectionUnit:selectionUnit completion:^(NSDate * _Nonnull start, NSDate * _Nonnull end) {
        BKSleepQuery *result = [[self alloc] initWithSleepData:[BKSleepData selectWithStartDate:start endDate:end]];
        result.start = result.items.firstObject.start;
        result.end = result.items.lastObject.end;
        result.duration = (NSInteger)((result.end.timeIntervalSince1970 - result.start.timeIntervalSince1970) / 60.0);
        [result.items enumerateObjectsUsingBlock:^(BKSleepData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.sleepType == 1 || obj.sleepType == 2) {
                result.lightSleep += obj.duration;
            } else if (obj.sleepType == 3 || obj.sleepType == 4) {
                result.deepSleep += obj.duration;
            }
        }];
        [results addObject:result];
    }];
    return results;
}



@end
