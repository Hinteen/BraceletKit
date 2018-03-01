//
//  BKQueryDateControl.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BKQueryDateControlDelegate <NSObject>

@optional

/**
 查询日期改变了

 @param queryUnit 查询单位
 @param start 开始日期
 @param end 结束日期
 */
- (void)queryDateDidChanged:(BKQueryUnit)queryUnit start:(NSDate *)start end:(NSDate *)end;

@end

@interface BKQueryDateControl : UIView

/**
 unit
 */
@property (assign, nonatomic) BKQueryUnit currentQueryUnit;


@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;


/**
 delegate
 */
@property (weak, nonatomic) NSObject<BKQueryDateControlDelegate> *delegate;

- (instancetype)initWithDelegate:(NSObject<BKQueryDateControlDelegate> *)delegate;


/**
 刷新查询日期
 */
- (void)refreshQueryDate;


@end
