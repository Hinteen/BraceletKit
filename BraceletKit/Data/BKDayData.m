//
//  BKDayData.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDayData.h"
#import "_BKHeader.h"

@implementation BKDayData


+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKDayData *model = [BKDayData new];
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




+ (NSString *)tableName{
    return @"data_day";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"steps" comma:YES];
        [column appendDoubleColumn:@"distance" comma:YES];
        [column appendDoubleColumn:@"calorie" comma:YES];
        [column appendIntegerColumn:@"count" comma:YES];
        [column appendIntegerColumn:@"activity" comma:YES];
        
        [column appendIntegerColumn:@"avg_bpm" comma:YES];
        [column appendIntegerColumn:@"max_bpm" comma:YES];
        [column appendIntegerColumn:@"min_bpm" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, device_id";
}

+ (NSString *)orderBy{
    return @"steps";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDayData *model = [[BKDayData alloc] init];
    NSInteger date = [set longForColumnIndex:i++];// date
    model.dateInteger = date;
    i++;// device_id
    i++;// device_name
    model.steps = [set longForColumnIndex:i++];
    model.distance = [set doubleForColumnIndex:i++];
    model.calorie = [set doubleForColumnIndex:i++];
    model.count = [set longForColumnIndex:i++];
    model.activity = [set longForColumnIndex:i++];
    
    model.avgBpm = [set longForColumnIndex:i++];
    model.maxBpm = [set longForColumnIndex:i++];
    model.minBpm = [set longForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:bk_device_id() comma:YES];
    [value appendVarcharValue:bk_device_name() comma:YES];
    
    [value appendIntegerValue:self.steps comma:YES];
    [value appendDoubleValue:self.distance comma:YES];
    [value appendDoubleValue:self.calorie comma:YES];
    [value appendIntegerValue:self.count comma:YES];
    [value appendIntegerValue:self.activity comma:YES];
    
    [value appendIntegerValue:self.avgBpm comma:YES];
    [value appendIntegerValue:self.maxBpm comma:YES];
    [value appendIntegerValue:self.minBpm comma:YES];
    
    [value appendVarcharValue:bk_date_string(bk_today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return bk_device_id().length;
}



@end
