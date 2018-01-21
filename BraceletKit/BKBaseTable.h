//
//  BKBaseTable.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMResultSet;

@interface BKBaseTable : NSObject

/**
 表名
 */
@property (copy, readonly, class, nonatomic) NSString *tableName;

/**
 表版本
 */
@property (assign, readonly, class, nonatomic) CGFloat tableVersion;

/**
 列名
 */
@property (copy, readonly, class, nonatomic) NSString *tableColumns;

/**
 主键
 */
@property (copy, readonly, class, nonatomic) NSString *tablePrimaryKey;

+ (void)loadDatabase;

- (NSString *)valueString;
+ (instancetype)modelWithSet:(FMResultSet *)set;

/**
 当前实例是否可缓存

 @return 当前实例是否可缓存
 */
- (BOOL)cacheable;

- (BOOL)saveToDatabase;

@end
