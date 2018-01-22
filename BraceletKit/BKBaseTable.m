//
//  BKBaseTable.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKBaseTable.h"
#import "_BKDatabaseHelper.h"

@implementation BKBaseTable

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


- (BOOL)saveToDatabase{
    __block BOOL ret = NO;
    if (self.cacheable) {
        databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            ret = [db ax_replaceIntoTable:self.class.tableName column:self.class.tableColumns.stringByDeletingTypeAndComma value:self.valueString];
        });
    }
    return ret;
}

+ (void)loadDatabase{
    databaseTransaction(^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [db ax_createTable:self.tableName column:self.tableColumns primaryKey:self.tablePrimaryKey];
    });
}

@end
