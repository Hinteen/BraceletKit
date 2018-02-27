//
//  BKHeartRateData.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKHeartRateData.h"
#import "_BKHeader.h"


@implementation BKHeartRateData


- (instancetype)init{
    if (self = [super init]) {
        _timeDetail = [NSMutableArray arrayWithCapacity:5];
        _energyDetail = [NSMutableArray arrayWithCapacity:5];
        _hrDetail = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKHeartRateData *model = [[BKHeartRateData alloc] init];
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






+ (NSString *)tableName{
    return @"data_hr";
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
        [column appendIntegerColumn:@"hr_type" comma:YES];
        
        [column appendVarcharColumn:@"start" comma:YES];
        [column appendVarcharColumn:@"end" comma:YES];
        [column appendDoubleColumn:@"energy" comma:YES];
        
//        [column appendIntegerColumn:@"r1time" comma:YES];
//        [column appendIntegerColumn:@"r2time" comma:YES];
//        [column appendIntegerColumn:@"r3time" comma:YES];
//        [column appendIntegerColumn:@"r4time" comma:YES];
//        [column appendIntegerColumn:@"r5time" comma:YES];
//
//        [column appendDoubleColumn:@"r1energy" comma:YES];
//        [column appendDoubleColumn:@"r2energy" comma:YES];
//        [column appendDoubleColumn:@"r3energy" comma:YES];
//        [column appendDoubleColumn:@"r4energy" comma:YES];
//        [column appendDoubleColumn:@"r5energy" comma:YES];
//
//        [column appendIntegerColumn:@"r1hr" comma:YES];
//        [column appendIntegerColumn:@"r2hr" comma:YES];
//        [column appendIntegerColumn:@"r3hr" comma:YES];
//        [column appendIntegerColumn:@"r4hr" comma:YES];
//        [column appendIntegerColumn:@"r5hr" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, device_id, seq, hr_type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKHeartRateData *model = [[BKHeartRateData alloc] init];
    i++;// date
    i++;// device_id
    i++;// device_name
    model.seq = [set longForColumnIndex:i++];
    model.hrType = [set longForColumnIndex:i++];
    
    NSString *dateString = [set stringForColumnIndex:i++]; // start
    model.start = [bk_formatter() dateFromString:dateString];
    dateString = [set stringForColumnIndex:i++]; // end
    model.end = [bk_formatter() dateFromString:dateString];
    model.energy = [set doubleForColumnIndex:i++];
    
//    for (int j = 0; j < 5; j++) {
//        [model.timeDetail addObject:@([set longForColumnIndex:i++])];
//    }
//    for (int j = 0; j < 5; j++) {
//        [model.energyDetail addObject:@([set doubleForColumnIndex:i++])];
//    }
//    for (int j = 0; j < 5; j++) {
//        [model.hrDetail addObject:@([set longForColumnIndex:i++])];
//    }
    
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:bk_device_id() comma:YES];
    [value appendVarcharValue:bk_device_name() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.hrType comma:YES];
    
    [value appendVarcharValue:bk_date_string(self.start) comma:YES];
    [value appendVarcharValue:bk_date_string(self.end) comma:YES];
    [value appendDoubleValue:self.energy comma:YES];
    
//    for (int j = 0; j < 5; j++) {
//        [value appendIntegerValue:self.timeDetail[j].integerValue comma:YES];
//    }
//    for (int j = 0; j < 5; j++) {
//        [value appendDoubleValue:self.energyDetail[j].doubleValue comma:YES];
//    }
//    for (int j = 0; j < 5; j++) {
//        [value appendIntegerValue:self.hrDetail[j].integerValue comma:YES];
//    }
    
    [value appendVarcharValue:bk_date_string(bk_today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return bk_device_id().length && self.dateInteger;
}



@end

