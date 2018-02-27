//
//  BKSportList.m
//  BraceletKit
//
//  Created by xaoxuu on 22/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSportList.h"
#import "_BKHeader.h"
#import "BKDevice.h"

@implementation BKSportList

+ (NSString *)tableName{
    return @"sport_list";
}

+ (NSString *)tableColumns{
    static NSString *columnName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString *column = [NSMutableString string];
        [column appendVarcharColumn:@"model" comma:YES];
        [column appendVarcharColumn:@"type" comma:YES];
        [column appendVarcharColumn:@"name" comma:YES];
        [column appendVarcharColumn:@"unit" comma:YES];
        
        [column appendVarcharColumn:@"lastmodified" comma:NO];
        columnName = column;
    });
    return columnName;
}
+ (NSString *)tablePrimaryKey{
    return @"model, type";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    int i = 0;
    BKSportList *model = [[BKSportList alloc] init];
    i++;// model
    model.type = [set intForColumnIndex:i++];
    model.name = [set stringForColumnIndex:i++];
    model.unit = [set stringForColumnIndex:i++];
    
    return model;
}

- (NSString *)valueString{
    NSMutableString *value = [NSMutableString string];
    [value appendVarcharValue:[BKDevice currentDevice].model comma:YES];
    [value appendIntegerValue:self.type comma:YES];
    [value appendVarcharValue:self.name comma:YES];
    [value appendVarcharValue:self.unit comma:YES];
    
    [value appendVarcharValue:bk_date_string(bk_today()) comma:NO];
    return value;
}

- (BOOL)cacheable{
    return [UIDevice currentDevice].model.length && ![[UIDevice currentDevice].model isEqualToString:@"(null)"];
}

- (NSString *)whereExists{
    return [NSString stringWithFormat:@"model = '%@' and type = %d", [UIDevice currentDevice].model, self.type];
}

@end
