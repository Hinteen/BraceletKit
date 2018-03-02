//
//  BKHeartRateHourData.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKHeartRateHourData.h"
#import "_BKHeader.h"


@implementation BKHeartRateHourData


- (instancetype)init{
    if (self = [super init]) {
        _hrDetail = [NSMutableArray arrayWithCapacity:60];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict{
    BKHeartRateHourData *model = [[BKHeartRateHourData alloc] init];
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



+ (NSString *)tableName{
    return @"data_hr_hour";
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
        [column appendIntegerColumn:@"hour" comma:YES];
        
        [column appendVarcharColumn:@"detail" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, device_id, hour";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKHeartRateHourData *model = [[BKHeartRateHourData alloc] init];
    i++;// date
    i++;// device_id
    i++;// device_name
    model.seq = [set longForColumnIndex:i++];
    model.hour = [set longForColumnIndex:i++];
    
    NSString *detailString = [set stringForColumnIndex:i++];
    NSData *data = [detailString dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        model.hrDetail = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:self.dateInteger comma:YES];
    [value appendVarcharValue:bk_device_id() comma:YES];
    [value appendVarcharValue:bk_device_name() comma:YES];
    
    [value appendIntegerValue:self.seq comma:YES];
    [value appendIntegerValue:self.hour comma:YES];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.hrDetail options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [value appendVarcharValue:jsonStr comma:YES];
    
    [value appendVarcharValue:bk_date_string(bk_today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return bk_device_id().length && self.dateInteger;
}


@end
