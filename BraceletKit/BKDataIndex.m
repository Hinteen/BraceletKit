//
//  BKDataIndex.m
//  BraceletKit
//
//  Created by xaoxuu on 21/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKDataIndex.h"
#import <AXKit/AXKit.h>


@implementation BKDataIndex

+ (instancetype)modelWithDict:(NSDictionary<NSString *, NSString *> *)dict{
    BKDataIndex *model = [BKDataIndex new];
    model.total = [dict integerValueForKey:@"total"];
    model.start = [dict integerValueForKey:@"start"];
    model.end = [dict integerValueForKey:@"end"];
    return model;
}

@end
