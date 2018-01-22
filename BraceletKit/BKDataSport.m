//
//  BKDataSport.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDataSport.h"
#import "_BKHeader.h"

@implementation BKDataSport

+ (void)load{
    [self createTableIfNotExists];
}



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




+ (NSString *)tableName{
    return @"data_sport";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"user_id" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendIntegerColumn:@"seq" comma:YES];
        [column appendIntegerColumn:@"sport_type" comma:YES];
        
        [column appendVarcharColumn:@"start" comma:YES];
        [column appendVarcharColumn:@"end" comma:YES];
        [column appendIntegerColumn:@"activity" comma:YES];
        
        [column appendIntegerColumn:@"steps" comma:YES];
        [column appendDoubleColumn:@"distance" comma:YES];
        [column appendDoubleColumn:@"calorie" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, user_id, device_id, seq, sport_type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataSport *model = [[BKDataSport alloc] init];
    i++;// date
    i++;// user_id
    i++;// device_id
    i++;// device_name
    model.seq = [set longForColumnIndex:i++];
    model.sportType = [set longForColumnIndex:i++];
    
    NSString *dateString = [set stringForColumnIndex:i++]; // start
    model.start = [formatter() dateFromString:dateString];
    dateString = [set stringForColumnIndex:i++]; // end
    model.end = [formatter() dateFromString:dateString];
    model.activity = [set longForColumnIndex:i++];
    
    model.steps = [set longForColumnIndex:i++];
    model.distance = [set doubleForColumnIndex:i++];
    model.calorie = [set doubleForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:userId() comma:YES];
    [value appendVarcharValue:deviceId() comma:YES];
    [value appendVarcharValue:deviceName() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.sportType comma:YES];
    
    [value appendVarcharValue:dateString(self.start) comma:YES];
    [value appendVarcharValue:dateString(self.end) comma:YES];
    [value appendIntegerValue:self.activity comma:YES];
    
    [value appendIntegerValue:self.steps comma:YES];
    [value appendDoubleValue:self.distance comma:YES];
    [value appendDoubleValue:self.calorie comma:YES];
    
    [value appendVarcharValue:dateString(today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return userId().length && deviceId().length && self.dateInteger;
}


@end
