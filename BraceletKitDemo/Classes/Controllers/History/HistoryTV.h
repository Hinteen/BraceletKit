//
//  HistoryTV.h
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import <AXKit/AXKit.h>

@interface HistoryTV : AXTableView

/**
 unit
 */
@property (assign, nonatomic) BKQueryUnit currentQueryUnit;


@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;



@end
