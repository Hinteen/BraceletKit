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


/**
 加载数据库
 */
+ (void)loadDatabase;

/**
 生成valuestring

 @return valuestring
 */
- (NSString *)valueString;

/**
 set转model

 @param set set
 @return model
 */
+ (instancetype)modelWithSet:(FMResultSet *)set;

/**
 当前实例满足什么条件可缓存

 @return 当前实例满足什么条件可缓存
 */
- (BOOL)cacheable;

/**
 可以确定这条数据存在的where语句

 @return 可以确定这条数据存在的where语句
 */
- (NSString *)whereExists;

/**
 从数据库中恢复这条数据

 @return 从数据库中恢复这条数据
 */
- (instancetype)restoreFromDatabase;

/**
 保存到数据库

 @return 是否成功
 */
- (BOOL)saveToDatabase;



@end
