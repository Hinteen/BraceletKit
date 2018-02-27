//
//  BKDefines.m
//  BraceletKit
//
//  Created by xaoxuu on 20/01/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "_BKHeader.h"
#import "BKUser.h"
#import "BKDevice.h"

inline NSDateFormatter *bk_formatter(){
    static NSDateFormatter *fm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fm = [[NSDateFormatter alloc] init];
        fm.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    });
    return fm;
}

inline NSDate *bk_today(){
    return [NSDate date];
}

inline NSString *bk_device_id(){
    return [BKDevice currentDevice].mac;
}

inline NSString *bk_device_name(){
    return [BKDevice currentDevice].name;
}

inline NSString *bk_date_string(NSDate *date){
    return [bk_formatter() stringFromDate:date];
}


@implementation BKDefines

@end
