//
//  BKSportQuery.m
//  BraceletKit
//
//  Created by xaoxuu on 23/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSportQuery.h"
#import "BKDataSport.h"

@implementation BKSportQuery

- (instancetype)initWithSportData:(BKDataSport *)model{
    if (self = [self init]) {
        self.start = model.start;
        self.end = model.end;
        self.activity = model.activity;
        self.steps = model.steps;
        self.distance = model.distance;
        self.calorie = model.calorie;
    }
    return self;
}


+ (NSArray<BKQuery *> *)querySummaryWithDate:(NSDate *)date{
    NSArray<BKDataSport *> *sports = [BKDataSport selectFromDatabaseWithDate:date];
    NSMutableArray<BKSportQuery *> *results = [NSMutableArray array];
    [sports enumerateObjectsUsingBlock:^(BKDataSport * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BKSportQuery *model = [[BKSportQuery alloc] initWithSportData:obj];
        [results addObject:model];
    }];
    return results;
}

@end
