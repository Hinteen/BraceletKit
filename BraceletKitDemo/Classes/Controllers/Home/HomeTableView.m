//
//  HomeTableView.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 10/11/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "HomeTableView.h"
#import "BKSportQuery.h"

@interface HomeTableView()

@property (strong, nonatomic) BKSportQuery *query;

@end

@implementation HomeTableView




- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    self.query = [BKSportQuery querySummaryWithDate:[NSDate date] unit:BKQueryUnitDaily].lastObject;
    
    
    [self reloadData];
}


- (void)ax_tableViewCell:(AXTableViewCellType *)cell willSetModel:(AXTableRowModelType *)model forRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModel *row = (AXTableRowModel *)model;
    if (indexPath.section == 0 && self.query) {
        if ([row.title isEqualToString:@"步数"]) {
            row.detail = [NSString stringWithFormat:@"%d steps", self.query.steps.intValue];
        } else if ([row.title isEqualToString:@"距离"]) {
            row.detail = [NSString stringWithFormat:@"%.2f km", self.query.distance.doubleValue / 1000.0f];
        } else if ([row.title isEqualToString:@"卡路里"]) {
            row.detail = [NSString stringWithFormat:@"%.1f cal", self.query.calorie.doubleValue];
        } else if ([row.title isEqualToString:@"活动时间"]) {
            row.detail = [NSString stringWithFormat:@"%d minutes", self.query.activity.intValue];
        }
    }
    
    
}



@end
