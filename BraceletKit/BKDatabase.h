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
#import "BKDataIndex.h"
#import "BKDataDay.h"
#import "BKDataSport.h"
#import "BKDataHR.h"
#import "BKDataHRHour.h"
#import "BKDataSleep.h"



@interface BKUser (BKBaseTable)

+ (instancetype)loadUserWithEmail:(NSString *)email;

@end

@interface BKDevice (BKBaseTable)

+ (instancetype)lastConnectedDevice;

- (NSString *)restoreMac;

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
