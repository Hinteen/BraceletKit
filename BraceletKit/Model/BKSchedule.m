//
//  BKSchedule.m
//  BraceletKit
//
//  Created by xaoxuu on 24/03/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "BKSchedule.h"
#import "_BKHeader.h"

@implementation BKSchedule

- (ZRSchedule *)transformToZRSchedule{
    NSDate *date = self.date;
    NSInteger year = date.stringValue(@"yyyy").integerValue;
    NSInteger month = date.stringValue(@"MM").integerValue;
    NSInteger day = date.stringValue(@"dd").integerValue;
    NSInteger hour = date.stringValue(@"HH").integerValue;
    NSInteger minute = date.stringValue(@"mm").integerValue;
    ZRSchedule *model = [[ZRSchedule alloc] initWithTitile:self.title subTitle:self.subtitle year:year month:month day:day hour:hour minute:minute];
    return model;
}

@end
