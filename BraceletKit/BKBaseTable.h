//
//  BKBaseTable.h
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDatabase.h"

@class FMResultSet;



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
