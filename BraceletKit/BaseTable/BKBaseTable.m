//
//  BKBaseTable.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKBaseTable.h"
#import "_BKHeader.h"


@interface BKBaseTable() <BKDatabase>

@end

@implementation BKBaseTable

//@required

+ (NSString *)tableName{
    NSAssert(NO, @"子类必须重写此方法");
    return @"";
}
+ (CGFloat)tableVersion{
    return 0;
}
+ (NSString *)tableColumns{
    NSAssert(NO, @"子类必须重写此方法");
    return @"";
}
+ (NSString *)tablePrimaryKey{
    NSAssert(NO, @"子类必须重写此方法");
    return @"";
}

+ (instancetype)modelWithSet:(FMResultSet *)set{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

- (BOOL)cacheable{
    NSAssert(NO, @"子类必须重写此方法");
    return NO;
}


- (NSString *)valueString{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

- (NSString *)whereExists{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

- (instancetype)restoreFromDatabase{
    NSAssert(NO, @"子类必须重写此方法");
    return nil;
}

- (BOOL)saveToDatabase{
    __block BOOL ret = NO;
    if (self.cacheable) {
        databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            ret = [db ax_replaceIntoTable:self.class.tableName column:self.class.tableColumns.stringByDeletingTypeAndComma value:self.valueString];
        });
    }
    return ret;
}

+ (void)createTableIfNotExists{
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db ax_createTable:self.tableName column:self.tableColumns primaryKey:self.tablePrimaryKey];
    });
}



+ (void)select:(NSString *)select where:(NSString *(^)(void))where result:(void (^)(FMResultSet *))result{
    if (where) {
        NSString *callback = where();
        if (callback.length) {
            NSString *whereStr = [NSString stringWithFormat:@"user_id = '%@' and device_id = '%@' and %@", bk_user_id(), bk_device_id(), callback];
            databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
                [db ax_select:select from:self.tableName where:^NSString * _Nonnull{
                    return whereStr;
                } orderBy:@"lastmodified" result:result];
            });
        }
    }
}

+ (void)select:(NSString *)select date:(NSDate *)date unit:(BKQueryUnit)unit result:(void (^)(FMResultSet * _Nonnull))result{
    if (date) {
        [self select:select where:^NSString * _Nonnull{
            if (unit == BKQueryUnitDaily) {
                return [NSString stringWithFormat:@"date = %08d", date.intValue];
            } else {
                NSDate *start;
                NSDate *end;
                if (unit == BKQueryUnitWeekly) {
                    NSInteger weekday = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday]; // 1~7
                    start = date.addDays(1-weekday);
                    end = start.addWeeks(1);
                    return [NSString stringWithFormat:@"date >= %08d and date < %08d", start.intValue, end.intValue];
                } else if (unit == BKQueryUnitMonthly) {
                    int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
                    int month = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:date] month]; // 1~12
                    return [NSString stringWithFormat:@"date >= %04d%02d00 and date < %04d%02d00", year, month, year, month+1];
                } else if (unit == BKQueryUnitYearly) {
                    int year = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:date] year];
                    return [NSString stringWithFormat:@"date >= %04d0000 and date < %04d0000", year, year+1];
                } else {
                    return nil;
                }
            }
        } result:result];
    }
}

+ (void)select:(NSString *)select startDate:(NSDate *)startDate endDate:(NSDate *)endDate result:(void (^)(FMResultSet *set))result{
    if (startDate && endDate) {
        [self select:select where:^NSString * _Nonnull{
            return [NSString stringWithFormat:@"date >= %08d and date < %08d", startDate.intValue, endDate.intValue];
        } result:result];
    }
}

+ (NSArray<BKBaseTable *> *)selectWhere:(NSString *)where{
    NSMutableArray *results = [NSMutableArray array];
    [self select:@"*" where:^NSString * _Nonnull{
        return where;
    } result:^(FMResultSet * _Nonnull set) {
        [results addObject:[self modelWithSet:set]];
    }];
    return results;
}

+ (NSArray<BKBaseTable *> *)selectWithDate:(NSDate *)date unit:(BKQueryUnit)unit{
    NSMutableArray *results = [NSMutableArray array];
    [self select:@"*" date:date unit:unit result:^(FMResultSet * _Nonnull set) {
        [results addObject:[self modelWithSet:set]];
    }];
    return results;
}

+ (NSArray<BKBaseTable *> *)selectWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSMutableArray *results = [NSMutableArray array];
    [self select:@"*" startDate:startDate endDate:endDate result:^(FMResultSet *set) {
        [results addObject:[self modelWithSet:set]];
    }];
    return results;
}



@end
