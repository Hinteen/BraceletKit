//
//  HistoryTV.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HistoryTV.h"
#import "BKSportData.h"
#import "BKSportQuery.h"
#import "BKHeartRateQuery.h"
#import "BKSleepQuery.h"


@interface HistoryTV ()

@property (strong, nonatomic) NSArray<BKSportQuery *> *sport;

@property (strong, nonatomic) NSArray<BKHeartRateQuery *> *hr;

@property (strong, nonatomic) NSArray<BKSleepQuery *> *sleep;

@end

@implementation HistoryTV


- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    
    self.sport = [BKSportQuery querySummaryWithDate:self.start unit:self.currentQueryUnit];
    self.hr = [BKHeartRateQuery querySummaryWithDate:self.start unit:self.currentQueryUnit];
//    self.sleep = [BKSleepQuery querySummaryWithDate:self.start unit:self.currentQueryUnit];
    
    AXTableModel *dataList = [[AXTableModel alloc] init];
    int sumOfSteps = [[self.sport valueForKeyPath:@"steps.@sum.doubleValue"] intValue];
    double sumOfDistance = [[self.sport valueForKeyPath:@"distance.@sum.doubleValue"] doubleValue] / 1000.0f;
    double sumOfCalorie = [[self.sport valueForKeyPath:@"calorie.@sum.doubleValue"] doubleValue];
    int sumOfActivities = [[self.sport valueForKeyPath:@"activity.@sum.doubleValue"] intValue];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = [NSString stringWithFormat:@"总数据"];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总步数";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d steps", sumOfSteps];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总距离";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.2f km", sumOfDistance];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总卡路里";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.1f cal", sumOfCalorie];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总活动时间";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d minutes", sumOfActivities];
        }];
    }];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = [NSString stringWithFormat:@"日均数据"];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均步数";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d steps", sumOfSteps/(int)self.sport.count];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均距离";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.2f km", sumOfDistance/(double)self.sport.count];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均卡路里";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.1f cal", sumOfCalorie/(double)self.sport.count];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均活动时间";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d minutes", sumOfActivities/(int)self.sport.count];
        }];
//        [section addRow:^(AXTableRowModel *row) {
//            row.title = @"日均睡眠时长";
//            row.target = @"";
//            int sum = [[self.sport valueForKeyPath:@"steps.@sum.doubleValue"] intValue];
//            row.detail = [NSString stringWithFormat:@"%d", sum/(int)self.sport.count];
//        }];
        
        
    }];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"活动记录";
        [self.sport enumerateObjectsUsingBlock:^(BKSportQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.items enumerateObjectsUsingBlock:^(BKSportData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [section addRow:^(AXTableRowModel *row) {
                    row.title = [NSString stringWithFormat:@"%@ (%@ - %@)", obj.start.stringValue(@"MM-dd"), obj.start.stringValue(@"HH:mm"), obj.end.stringValue(@"HH:mm")];
                    row.detail = [NSString stringWithFormat:@"%d steps", (int)obj.steps];
                }];
            }];
        }];
    }];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"步数趋势";
        
    }];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"心率记录";
        
    }];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"睡眠记录";
        
    }];
    
    dataSource(dataList);
    
}

- (void)ax_tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self tableViewRowModelForIndexPath:indexPath];
    
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.dataList.sections[section].headerTitle;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.dataList.sections[section].footerHeight;
}




@end
