//
//  BKDataHR.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDataHR.h"
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


@implementation BKDataHR

- (instancetype)init{
    if (self = [super init]) {
        _timeDetail = [NSMutableArray arrayWithCapacity:5];
        _energyDetail = [NSMutableArray arrayWithCapacity:5];
        _hrDetail = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKDataHR *model = [[BKDataHR alloc] init];
    int year = (int)[dict integerValueForKey:@"year"];
    int month = (int)[dict integerValueForKey:@"month"];
    int day = (int)[dict integerValueForKey:@"day"];
    int start_time = (int)[dict integerValueForKey:@"start_time"];
    int end_time = (int)[dict integerValueForKey:@"end_time"];
    NSString *dateStr = [NSString stringWithFormat:@"%04d%02d%02d", year, month, day];
    model.dateInteger = dateStr.integerValue;
    
    model.seq = [dict integerValueForKey:@"seq"];
    
    int hour = start_time / 60;
    int minute = start_time % 60;
    dateStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:00 +0800", year, month, day, hour, minute];
    model.start = [formatter() dateFromString:dateStr];
    hour = end_time / 60;
    minute = end_time % 60;
    dateStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:00 +0800", year, month, day, hour, minute];
    model.end = [formatter() dateFromString:dateStr];
    
    NSString *detailDataString = [dict stringValueForKey:@"detail_data"];
    NSData *data = [detailDataString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        model.hrType = [dic integerValueForKey:@"hr_type"];
        model.energy = [dic doubleValueForKey:@"energy"];
        [model.timeDetail addObject:@([dict doubleValueForKey:@"r1Time"])];
        [model.timeDetail addObject:@([dict doubleValueForKey:@"r2Time"])];
        [model.timeDetail addObject:@([dict doubleValueForKey:@"r3Time"])];
        [model.timeDetail addObject:@([dict doubleValueForKey:@"r4Time"])];
        [model.timeDetail addObject:@([dict doubleValueForKey:@"r5Time"])];
        [model.energyDetail addObject:@([dict doubleValueForKey:@"r1Energy"])];
        [model.energyDetail addObject:@([dict doubleValueForKey:@"r2Energy"])];
        [model.energyDetail addObject:@([dict doubleValueForKey:@"r3Energy"])];
        [model.energyDetail addObject:@([dict doubleValueForKey:@"r4Energy"])];
        [model.energyDetail addObject:@([dict doubleValueForKey:@"r5Energy"])];
        [model.hrDetail addObject:@([dict doubleValueForKey:@"r1Hr"])];
        [model.hrDetail addObject:@([dict doubleValueForKey:@"r2Hr"])];
        [model.hrDetail addObject:@([dict doubleValueForKey:@"r3Hr"])];
        [model.hrDetail addObject:@([dict doubleValueForKey:@"r4Hr"])];
        [model.hrDetail addObject:@([dict doubleValueForKey:@"r5Hr"])];
    }
    
    return model;
}


@end

