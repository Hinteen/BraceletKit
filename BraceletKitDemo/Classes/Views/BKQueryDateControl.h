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


- (void)refreshQueryDate;

- (void)queryDateDidChanged:(void (^)(BKQueryUnit currentQueryUnit, NSDate *start, NSDate *end))op;

@end
