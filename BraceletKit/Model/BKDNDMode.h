//
//  BKDNDMode.h
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKDefines.h"

@interface BKDNDMode : NSObject

/**
 dnd type
 */
@property (assign, nonatomic) BKDNDType type;
/**
 start hour
 */
@property (assign, nonatomic) NSInteger startHour;
/**
 start minute
 */
@property (assign, nonatomic) NSInteger startMinute;

/**
 end hour
 */
@property (assign, nonatomic) NSInteger endHour;
/**
 end minute
 */
@property (assign, nonatomic) NSInteger endMinute;

@end


/**
 When dndtype == DNDTypeNull, mean this smartBand has not set dnd model; you can also set dndType = 0 to close dnd model
 */
//@property(nonatomic,assign)NSInteger dndType;
//@property(nonatomic,assign)NSInteger startHour;
//@property(nonatomic,assign)NSInteger startMinute;
//
//@property(nonatomic,assign)NSInteger endHour;
//@property(nonatomic,assign)NSInteger endMinute;

