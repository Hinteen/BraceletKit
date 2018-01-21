//
//  BKSportDay.h
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDevice.h"
#import "BKUser.h"


@interface BKSportDay : NSObject

/**
 device
 */
@property (strong, nonatomic) BKDevice *device;

/**
 user
 */
@property (strong, nonatomic) BKUser *user;

/**
 date
 */
@property (assign, nonatomic) NSInteger dateInteger;

/**
 steps
 */
@property (assign, nonatomic) NSInteger steps;

/**
 distance
 */
@property (assign, nonatomic) CGFloat distance;

/**
 calorie
 */
@property (assign, nonatomic) CGFloat calorie;

/**
 avg bpm
 */
@property (assign, nonatomic) NSInteger avgBpm;

/**
 max bpm
 */
@property (assign, nonatomic) NSInteger maxBpm;

/**
 min bpm
 */
@property (assign, nonatomic) NSInteger minBpm;



@end

