//
//  BKData.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKData.h"
#import "_BKHeader.h"
#import "BKServices.h"

@interface BKServices() <BKDataObserver>

@end

@interface BKData() <BKData>

@end

@implementation BKData

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
    if (ret) {
        if ([[BKServices sharedInstance] respondsToSelector:@selector(dataDidUpdated:)]) {
            [[BKServices sharedInstance] dataDidUpdated:self];
        }
    }
    return ret;
}

+ (void)createTableIfNotExists{
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db ax_createTable:self.tableName column:self.tableColumns primaryKey:self.tablePrimaryKey];
    });
}


+ (NSString *)defaultWhereString{
    return [NSString stringWithFormat:@"device_id = '%@'", bk_device_id()];
}

+ (NSString *)orderBy{
    return @"lastmodified";
}

+ (void)select:(NSString *)select where:(NSString *(^)(void))where result:(void (^)(FMResultSet *))result{
    if (where) {
        NSString *whereStr = [self defaultWhereString];
        NSString *callback = where();
        if (callback.length) {
            whereStr = [NSString stringWithFormat:@"%@ and %@", whereStr, callback];
        }
        databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            [db ax_select:select from:self.tableName where:^NSString * _Nonnull{
                return whereStr;
            } orderBy:self.orderBy result:result];
        });
    }
}


+ (void)select:(NSString *)select startDate:(NSDate *)startDate endDate:(NSDate *)endDate result:(void (^)(FMResultSet *set))result{
    if (startDate && endDate) {
        [self select:select where:^NSString * _Nonnull{
            return [NSString stringWithFormat:@"date >= %08d and date < %08d", startDate.intValue, endDate.intValue];
        } result:result];
    }
}

+ (NSArray<BKData *> *)selectWhere:(NSString *)where{
    NSMutableArray *results = [NSMutableArray array];
    [self select:@"*" where:^NSString * _Nonnull{
        return where;
    } result:^(FMResultSet * _Nonnull set) {
        [results addObject:[self modelWithSet:set]];
    }];
    return results;
}


+ (NSArray<BKData *> *)selectWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    NSMutableArray *results = [NSMutableArray array];
    [self select:@"*" startDate:startDate endDate:endDate result:^(FMResultSet *set) {
        [results addObject:[self modelWithSet:set]];
    }];
    return results;
}



@end
