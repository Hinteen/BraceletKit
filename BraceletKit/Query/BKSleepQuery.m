//
//  BKSleepQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSleepQuery.h"
#import "BKDataSleep.h"

@implementation BKSleepQuery


- (instancetype)init{
    if (self = [super init]) {
        self.detail = [NSMutableArray array];
    }
    return self;
}

// 必须传入24个小时的每小时心率
- (instancetype)initWithSleepData:(NSArray<BKDataSleep *> *)sleeps{
    if (self = [self init]) {
#warning 123
    }
    return self;
}



@end
