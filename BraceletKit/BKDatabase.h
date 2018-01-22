//
//  BKDatabase.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BKUser.h"
//#import "BKDevice.h"
//#import "BKDeviceSetting.h"
//#import "BKDataIndex.h"
//#import "BKDataDay.h"
//#import "BKDataSport.h"
//#import "BKDataHR.h"
//#import "BKDataHRHour.h"
//#import "BKDataSleep.h"
//#import "BKSportList.h"

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

//
//@interface BKUser (BKBaseTable)
//
//+ (instancetype)loadUserWithEmail:(NSString *)email;
//
//@end
//
//@interface BKDevice (BKBaseTable)
//
//+ (instancetype)lastConnectedDevice;
//
//- (NSString *)restoreMac;
//
//@end
//
//@interface BKDeviceSetting (BKBaseTable)
//
//
///**
// 如果不存在的话就保存到数据库，如果存在，就不做任何操作
//
// @return 结果
// */
//- (BOOL)saveToDatabaseIfNotExists;
//
//@end
//
//@interface BKSportList (BKBaseTable)
//
//
//@end
//
//
//
//
//
//@interface BKDataIndex (BKBaseTable)
//
//
//@end
//
//@interface BKDataDay (BKBaseTable)
//
//
//@end
//
//@interface BKDataSport (BKBaseTable)
//
//
//@end
//
//@interface BKDataHR (BKBaseTable)
//
//
//@end
//
//@interface BKDataHRHour (BKBaseTable)
//
//
//@end
//
//@interface BKDataSleep (BKBaseTable)
//
//
//@end

//@interface BKDatabase : NSObject
//
//+ (void)loadDatabase;
//
//@end

