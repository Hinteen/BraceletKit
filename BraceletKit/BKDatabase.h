//
//  BKDatabase.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKUser.h"
#import "BKDevice.h"
#import "BKDeviceSetting.h"
#import "BKDataIndex.h"
#import "BKDataDay.h"
#import "BKDataSport.h"
#import "BKDataHR.h"
#import "BKDataHRHour.h"
#import "BKDataSleep.h"
#import "BKSportList.h"


@interface BKUser (BKBaseTable)

+ (instancetype)loadUserWithEmail:(NSString *)email;

@end

@interface BKDevice (BKBaseTable)

+ (instancetype)lastConnectedDevice;

- (NSString *)restoreMac;

@end

@interface BKDeviceSetting (BKBaseTable)


/**
 如果不存在的话就保存到数据库，如果存在，就不做任何操作
 
 @return 结果
 */
- (BOOL)saveToDatabaseIfNotExists;

@end

@interface BKSportList (BKBaseTable)


@end





@interface BKDataIndex (BKBaseTable)


@end

@interface BKDataDay (BKBaseTable)


@end

@interface BKDataSport (BKBaseTable)


@end

@interface BKDataHR (BKBaseTable)


@end

@interface BKDataHRHour (BKBaseTable)


@end

@interface BKDataSleep (BKBaseTable)


@end

@interface BKDatabase : NSObject

+ (void)loadDatabase;

@end
