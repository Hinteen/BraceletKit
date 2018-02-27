//
//  BKDataIndex.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDataIndex.h"
#import "_BKHeader.h"


@implementation BKDataIndex


+ (instancetype)modelWithDict:(NSDictionary<NSString *, NSString *> *)dict{
    BKDataIndex *model = [BKDataIndex new];
    model.total = [dict integerValueForKey:@"total"];
    model.start = [dict integerValueForKey:@"start"];
    model.end = [dict integerValueForKey:@"end"];
    return model;
}




+ (NSString *)tableName{
    return @"data_index";
}
+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendIntegerColumn:@"date" comma:YES];
        [column appendVarcharColumn:@"device_id" comma:YES];
        [column appendVarcharColumn:@"device_name" comma:YES];
        
        [column appendVarcharColumn:@"data_type" comma:YES];
        [column appendIntegerColumn:@"total" comma:YES];
        [column appendIntegerColumn:@"start" comma:YES];
        [column appendIntegerColumn:@"end" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"date, device_id, data_type, start";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKDataIndex *model = [[BKDataIndex alloc] init];
    i++;// date
    i++;// device_id
    i++;// device_name
    model.dataType = [set stringForColumnIndex:i++];
    model.total = [set longForColumnIndex:i++];
    model.start = [set longForColumnIndex:i++];
    model.end = [set longForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendIntegerValue:bk_today().integerValue comma:YES];
    [value appendVarcharValue:bk_device_id() comma:YES];
    [value appendVarcharValue:bk_device_name() comma:YES];
    
    [value appendVarcharValue:self.dataType comma:YES];
    [value appendIntegerValue:self.total comma:YES];
    [value appendIntegerValue:self.start comma:YES];
    [value appendIntegerValue:self.end comma:YES];
    
    [value appendVarcharValue:bk_date_string(bk_today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return bk_device_id().length && self.dataType.length;
}


@end
