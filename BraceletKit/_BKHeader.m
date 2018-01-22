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

inline NSDateFormatter *formatter(){
    static NSDateFormatter *fm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fm = [[NSDateFormatter alloc] init];
        fm.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    });
    return fm;
}

inline NSDate *today(){
    return [NSDate date];
}

inline NSString *userId(){
    return [BKUser currentUser].email;
}

inline NSString *deviceId(){
    return [BKDevice currentDevice].mac;
}

inline NSString *deviceName(){
    return [BKDevice currentDevice].name;
}

inline NSString *dateString(NSDate *date){
    return [formatter() stringFromDate:date];
}


@implementation BKDefines

@end
