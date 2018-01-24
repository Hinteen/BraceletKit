//
//  BKBaseTable.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMResultSet;

@protocol BKDatabase <NSObject>

@required
/**
 表名
 
 @return 表名
 */
+ (NSString *)tableName;
/**
 列名
 
 @return 列名
 */
+ (NSString *)tableColumns;
/**
 主键
 
 @return 主键
 */
+ (NSString *)tablePrimaryKey;


/**
 model转valuestring
 
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


@optional

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



@end


@interface BKBaseTable : NSObject


/**
 建表
 */
+ (void)createTableIfNotExists;

/**
 保存到数据库

 @return 是否成功
 */
- (BOOL)saveToDatabase;



@end
