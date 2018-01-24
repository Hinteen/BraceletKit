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

+ (NSArray<BKBaseTable *> *)selectFromDatabaseWhere:(NSString *)where{
    NSMutableArray *results = [NSMutableArray array];
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *whereStr = [NSString stringWithFormat:@"user_id = '%@' and device_id = '%@' and %@", bk_user_id(), bk_device_id(), where];
        [db ax_select:@"*" from:self.tableName where:whereStr orderBy:@"lastmodified" result:^(NSMutableArray * _Nonnull result, FMResultSet * _Nonnull set) {
            while (set.next) {
                [results addObject:[self modelWithSet:set]];
            }
        }];
    });
    return results;
}

@end
