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
        self.detail = [NSMutableArray array];
    }
    return self;
}


- (instancetype)initWithSleepData:(NSArray<BKSleepData *> *)sleeps{
    if (self = [self init]) {
#warning 123
    }
    return self;
}

//+ (NSArray<BKQuery *> *)querySummaryWithDate:(NSDate *)date unit:(BKQueryUnit)unit{
//
//}

@end
