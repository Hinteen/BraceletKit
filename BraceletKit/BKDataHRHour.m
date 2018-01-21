//
//  BKDataHRHour.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDataHRHour.h"
#import <AXKit/AXKit.h>


@implementation BKDataHRHour


- (instancetype)init{
    if (self = [super init]) {
        _hrDetail = [NSMutableArray arrayWithCapacity:60];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKDataHRHour *model = [[BKDataHRHour alloc] init];
    int year = (int)[dict integerValueForKey:@"year"];
    int month = (int)[dict integerValueForKey:@"month"];
    int day = (int)[dict integerValueForKey:@"day"];
    NSString *dateStr = [NSString stringWithFormat:@"%04d%02d%02d", year, month, day];
    model.dateInteger = dateStr.integerValue;
    
    model.seq = [dict integerValueForKey:@"seq"];
    model.hour = [dict integerValueForKey:@"hour"];
    
    model.hrDetail = [dict arrayValueForKey:@"detail_data"];
    
    return model;
}

@end
