//
//  BKSleepData.m
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSleepData.h"
#import "_BKHeader.h"


@implementation BKSleepData


- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKSleepData *model = [[BKSleepData alloc] init];
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
    model.start = [bk_formatter() dateFromString:dateStr];
    hour = end_time / 60;
    minute = end_time % 60;
    dateStr = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:00 +0800", year, month, day, hour, minute];
    model.end = [bk_formatter() dateFromString:dateStr];
    
    
    model.duration = [dict integerValueForKey:@"activity"];
    model.mode = [dict integerValueForKey:@"mode"];
    model.sleepType = [dict integerValueForKey:@"sleep_type"];
    model.sleepEnter = [dict integerValueForKey:@"sleep_enter"];
    model.sleepExit = [dict integerValueForKey:@"sleep_exit"];
    model.sportType = [dict integerValueForKey:@"sport_type"];
    
    return model;
}




+ (NSString *)tableName{
    return @"data_sleep";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"seq" comma:YES];
        [column appendIntegerColumn:@"sleep_type" comma:YES];
        [column appendIntegerColumn:@"mode" comma:YES];
        
        [column appendVarcharColumn:@"start" comma:YES];
        [column appendVarcharColumn:@"end" comma:YES];
        [column appendIntegerColumn:@"duration" comma:YES];
        
        [column appendIntegerColumn:@"sleep_enter" comma:YES];
        [column appendIntegerColumn:@"sleep_exit" comma:YES];
        [column appendIntegerColumn:@"sport_type" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, device_id, seq, sleep_type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKSleepData *model = [[BKSleepData alloc] init];
    i++;// date
    i++;// device_id
    i++;// device_name
    
    model.seq = [set longForColumnIndex:i++];
    model.sleepType = [set longForColumnIndex:i++];
    model.mode = [set longForColumnIndex:i++];
    
    NSString *dateString = [set stringForColumnIndex:i++];
    model.start = [bk_formatter() dateFromString:dateString];
    dateString = [set stringForColumnIndex:i++];
    model.end = [bk_formatter() dateFromString:dateString];
    model.duration = [set longForColumnIndex:i++];
    
    model.sleepEnter = [set longForColumnIndex:i++];
    model.sleepExit = [set longForColumnIndex:i++];
    model.sportType = [set longForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:bk_device_id() comma:YES];
    [value appendVarcharValue:bk_device_name() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.sleepType comma:YES];
    [value appendIntegerValue:self.mode comma:YES];
    
    [value appendVarcharValue:bk_date_string(self.start) comma:YES];
    [value appendVarcharValue:bk_date_string(self.end) comma:YES];
    [value appendIntegerValue:self.duration comma:YES];
    
    [value appendIntegerValue:self.sleepEnter comma:YES];
    [value appendIntegerValue:self.sleepExit comma:YES];
    [value appendIntegerValue:self.sportType comma:YES];
    
    [value appendVarcharValue:bk_date_string(bk_today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return bk_device_id().length && self.dateInteger;
}

@end
