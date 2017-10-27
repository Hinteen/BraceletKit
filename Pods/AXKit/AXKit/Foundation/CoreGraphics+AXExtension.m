//
//  CoreGraphics+AXExtension.m
//  AXKit
//
//  Created by xaoxuu on 05/03/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "CoreGraphics+AXExtension.h"


#pragma mark - 常量

const CGFloat kStatusBarHeight = 20;
const CGFloat kNavBarHeight = 44;
const CGFloat kTopBarHeight = 64;
const CGFloat kTabBarHeight = 49;

const CGFloat kMarginNarrow = 4;
const CGFloat kMarginNormal = 8;
const CGFloat kMarginWide = 16;

// @xaoxuu: 系统弹窗的宽度
const CGFloat kAlertWidth = 270.0f;


#pragma mark 取值范围创建


inline AXFloatRange AXFloatRangeMake(CGFloat minValue, CGFloat maxValue){
    return (AXFloatRange){minValue,maxValue};
}

inline AXIntegerRange AXIntegerRangeMake(NSInteger minValue, NSInteger maxValue){
    return (AXIntegerRange){minValue,maxValue};
}

inline AXUIntegerRange AXUIntegerRangeMake(NSUInteger minValue, NSUInteger maxValue){
    return (AXUIntegerRange){minValue,maxValue};
}



#pragma mark 确保值的范围

inline CGFloat AXMakeFloatInRange(CGFloat value, AXFloatRange range){
    value = MAX(value, range.minValue);
    value = MIN(value, range.maxValue);
    return value;
}

inline NSInteger AXMakeIntegerInRange(NSInteger value, AXIntegerRange range){
    value = MAX(value, range.minValue);
    value = MIN(value, range.maxValue);
    return value;
}

inline NSUInteger AXMakeUIntegerInRange(NSUInteger value, AXUIntegerRange range){
    value = MAX(value, range.minValue);
    value = MIN(value, range.maxValue);
    return value;
}

inline NSInteger AXSafeIndexForArray(NSInteger index, NSArray *array){
    index = MAX(0, index);
    index = MIN(index, array.count-1);
    return index;
}

#pragma mark 判断值是否在范围内

inline BOOL AXRangeContainsFloat(AXFloatRange range, CGFloat value){
    if (value >= range.minValue && value <= range.maxValue) {
        return YES;
    } else {
        return NO;
    }
}

inline BOOL AXRangeContainsInteger(AXIntegerRange range, NSInteger value){
    if (value >= range.minValue && value <= range.maxValue) {
        return YES;
    } else {
        return NO;
    }
}

inline BOOL AXRangeContainsUInteger(AXUIntegerRange range, NSUInteger value){
    if (value >= range.minValue && value <= range.maxValue) {
        return YES;
    } else {
        return NO;
    }
}





#pragma mark - 随机值

inline CGFloat AXRandomFloatFrom(AXFloatRange length){
    return length.minValue + (NSInteger)arc4random_uniform((int)length.maxValue-(int)length.minValue + 1);
}

inline NSInteger AXRandomIntegerFrom(AXIntegerRange length){
    return length.minValue + (NSInteger)arc4random_uniform((int)length.maxValue-(int)length.minValue + 1);
}

inline NSUInteger AXRandomUIntegerFrom(AXUIntegerRange length){
    return length.minValue + (NSUInteger)arc4random_uniform((int)length.maxValue-(int)length.minValue + 1);
}



#pragma mark - CGRect


inline CGRect CGRectFromScreen(){
    return [UIScreen mainScreen].bounds;
}


inline CGSize CGSizeUp(CGFloat upOffset){
    return CGSizeMake(0, -upOffset);
}

inline CGSize CGSizeDown(CGFloat downOffset){
    return CGSizeMake(0, downOffset);
}


inline CGRect CGRectWithTopMargin(CGFloat top){
    return CGRectMake(0, top, kScreenW, kScreenH-top);
}
inline CGRect CGRectWithTopAndBottomMargin(CGFloat top, CGFloat bottom){
    return CGRectMake(0, top, kScreenW, kScreenH-top-bottom);
}
