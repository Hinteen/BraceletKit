//
//  BKDataSport.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDataSport.h"
#import <AXKit/AXKit.h>


static inline NSDateFormatter *formatter(){
    static NSDateFormatter *fm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fm = [[NSDateFormatter alloc] init];
        fm.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    });
    return fm;
}

@implementation BKDataSport

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKDataSport *model = [BKDataSport new];
    int year = (int)[dict integerValueForKey:@"year"];
    int month = (int)[dict integerValueForKey:@"month"];
    int day = (int)[dict integerValueForKey:@"day"];
    int start_time = (int)[dict integerValueForKey:@"start_time"];
    int end_time = (int)[dict integerValueForKey:@"end_time"];
    NSString *dateStr = [NSString stringWithFormat:@"%04d%02d%02d", year, month, day];
    model.dateInteger = dateStr.integerValue;
    
    model.seq = [dict integerValueForKey:@"seq"];
    model.sportType = [dict integerValueForKey:@"sport_type"];
    
    int hour = start_time / 60;
    int minute = start_time % 60;
    dateStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:00 +0800", year, month, day, hour, minute];
    model.start = [formatter() dateFromString:dateStr];
    hour = end_time / 60;
    minute = end_time % 60;
    dateStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:00 +0800", year, month, day, hour, minute];
    model.end = [formatter() dateFromString:dateStr];
    model.activity = [dict integerValueForKey:@"activity"];
    
    
    model.steps = [dict integerValueForKey:@"steps"];
    model.distance = [dict doubleValueForKey:@"distance"];
    model.calorie = [dict doubleValueForKey:@"calorie"];
    return model;
}


@end
