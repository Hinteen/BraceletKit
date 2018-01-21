//
//  BKDataDay.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDataDay.h"
#import <AXKit/AXKit.h>

@implementation BKDataDay

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKDataDay *model = [BKDataDay new];
    int year = (int)[dict integerValueForKey:@"year"];
    int month = (int)[dict integerValueForKey:@"month"];
    int day = (int)[dict integerValueForKey:@"day"];
    NSString *dateStr = [NSString stringWithFormat:@"%04d%02d%02d", year, month, day];
    model.dateInteger = dateStr.integerValue;
    model.steps = [dict integerValueForKey:@"steps"];
    model.distance = [dict doubleValueForKey:@"distance"];
    model.calorie = [dict doubleValueForKey:@"calorie"];
    model.count = [dict integerValueForKey:@"count"];
    return model;
}

@end
