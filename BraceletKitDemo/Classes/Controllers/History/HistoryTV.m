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
#import "BKChartTVC.h"
#import "BKSleepData.h"

static NSString *chartReuseIdentifier = @"history table view cell for chart";

// 每小时显示几条心率
static NSInteger hourHRCount = 12;

@interface HistoryTV () <AXChartViewDataSource, AXChartViewDelegate>

@property (strong, nonatomic) NSArray<BKSportQuery *> *sport;

@property (strong, nonatomic) NSArray<BKHeartRateQuery *> *hr;

@property (strong, nonatomic) NSArray<BKSleepQuery *> *sleep;


@end

@implementation HistoryTV

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.start = [NSDate date];
        self.end = [NSDate date];
        self.queryViewUnit = BKQueryViewUnitWeekly;
        self.tableFooterView = UIViewWithHeight(60);
    }
    return self;
}



- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    
    BKQuerySelectionUnit unit = BKQuerySelectionUnitDaily;
    if (self.queryViewUnit == BKQueryViewUnitYearly) {
        unit = BKQuerySelectionUnitMonthly;
    }
    self.sport = [BKSportQuery querySummaryWithStartDate:self.start endDate:self.end selectionUnit:unit];
    self.hr = [BKHeartRateQuery querySummaryWithStartDate:self.start endDate:self.end selectionUnit:unit];
    self.sleep = [BKSleepQuery querySummaryWithStartDate:self.start endDate:self.end selectionUnit:unit];
    int count = (int)self.sport.count;
    if (self.queryViewUnit == BKQueryViewUnitYearly) {
        count = 365;
    }
    
    AXTableModel *dataList = [[AXTableModel alloc] init];
    int sumOfSteps = [[self.sport valueForKeyPath:@"steps.@sum.doubleValue"] intValue];
    double sumOfDistance = [[self.sport valueForKeyPath:@"distance.@sum.doubleValue"] doubleValue] / 1000.0f;
    double sumOfCalorie = [[self.sport valueForKeyPath:@"calorie.@sum.doubleValue"] doubleValue];
    int sumOfActivities = [[self.sport valueForKeyPath:@"activity.@sum.doubleValue"] intValue];
    int sumOfSleep = [[self.sleep valueForKeyPath:@"duration.@sum.doubleValue"] intValue];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = [NSString stringWithFormat:@"总数据"];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总步数";
            row.icon = @"icon_foot";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d steps", sumOfSteps];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总距离";
            row.icon = @"icon_distance";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.2f km", sumOfDistance];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总卡路里";
            row.icon = @"icon_calorie";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.1f cal", sumOfCalorie];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总活动时长";
            row.icon = @"icon_time";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d min", sumOfActivities];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"总睡眠时长";
            row.icon = @"icon_sleep";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%dh %dmin", (int)sumOfSleep/60, (int)sumOfSleep%60];
        }];
    }];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = [NSString stringWithFormat:@"日均数据"];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均步数";
            row.icon = @"icon_foot";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d steps", sumOfSteps/count];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均距离";
            row.icon = @"icon_distance";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.2f km", sumOfDistance/(double)count];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均卡路里";
            row.icon = @"icon_calorie";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%.1f cal", sumOfCalorie/(double)count];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均活动时长";
            row.icon = @"icon_time";
            row.target = @"";
            row.detail = [NSString stringWithFormat:@"%d min", sumOfActivities/count];
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"日均睡眠时长";
            row.icon = @"icon_sleep";
            row.target = @"";
            int min = sumOfSleep/count;
            row.detail = [NSString stringWithFormat:@"%dh %dmin", (int)min/60, (int)min%60];
        }];
        
        
    }];
    
    [self.sport enumerateObjectsUsingBlock:^(BKSportQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.items.count) {
            [dataList addSection:^(AXTableSectionModel *section) {
                if (self.queryViewUnit == BKQueryViewUnitYearly) {
                    section.headerTitle = [NSString stringWithFormat:@"活动记录 - %@", obj.date.stringValue(@"M月份")];
                } else {
                    section.headerTitle = [NSString stringWithFormat:@"活动记录 - %@", obj.date.stringValue(@"M月d号")];
                }
                [obj.items enumerateObjectsUsingBlock:^(BKSportData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [section addRow:^(AXTableRowModel *row) {
                        row.title = [NSString stringWithFormat:@"%@ - %@", obj.start.stringValue(@"HH:mm"), obj.end.stringValue(@"HH:mm")];
                        row.detail = [NSString stringWithFormat:@"%d steps", (int)obj.steps];
                        if (obj.steps >= 1000) {
                            row.icon = @"icon_run";
                            row.target = @"activity.1";
                        } else {
                            row.icon = @"icon_walk";
                            row.target = @"activity.0";
                        }
                        
                    }];
                }];
            }];
        }
    }];
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"";
        [section addRow:^(AXTableRowModel *row) {
            row.target = @"chart.steps";
        }];
    }];
    if (self.queryViewUnit == BKQueryViewUnitDaily) {
        [dataList addSection:^(AXTableSectionModel *section) {
            section.headerTitle = @"";
            [section addRow:^(AXTableRowModel *row) {
                row.target = @"chart.hr";
            }];
        }];
    }
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"睡眠详情";
        [self.sleep enumerateObjectsUsingBlock:^(BKSleepQuery * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.queryViewUnit == BKQueryViewUnitDaily) {
                [obj.items enumerateObjectsUsingBlock:^(BKSleepData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [section addRow:^(AXTableRowModel *row) {
                        row.title = [NSString stringWithFormat:@"(type: %d) %@ - %@", (int)obj.sleepType, obj.start.stringValue(@"HH:mm"), obj.end.stringValue(@"HH:mm")];
                        row.detail = [NSString stringWithFormat:@"%d min", (int)obj.duration];
                    }];
                }];
            } else {
                if (obj.items.count) {
                    [section addRow:^(AXTableRowModel *row) {
                        row.title = [NSString stringWithFormat:@"%@ (%@ - %@)", obj.start.stringValue(@"MM-dd"), obj.start.stringValue(@"HH:mm"), obj.end.stringValue(@"HH:mm")];
                        row.detail = [NSString stringWithFormat:@"%dh %dmin", (int)obj.duration/60, (int)obj.duration%60];
                    }];
                }
            }
        }];
    }];
    
    dataSource(dataList);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self tableViewRowModelForIndexPath:indexPath];
    if ([model.target containsString:@"chart."]) {
        BKChartTVC *cell = (BKChartTVC *)[tableView dequeueReusableCellWithIdentifier:chartReuseIdentifier];
        if (!cell) {
            cell = [[BKChartTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartReuseIdentifier];
        }
        cell.chartView.dataSource = self;
        cell.chartView.delegate = self;
        if ([model.target isEqualToString:@"chart.steps"]) {
            cell.chartView.title = @"步数详情";
            cell.chartView.smoothFactor = 0;
        } else if ([model.target isEqualToString:@"chart.hr"]) {
            cell.chartView.title = @"心率详情";
        }
        [cell.chartView reloadData];
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)ax_tableViewCell:(AXTableViewCellType *)cell willSetModel:(AXTableRowModelType *)model forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.imageView.tintColor = axThemeManager.color.theme;
    if ([model.target containsString:@"activity."]) {
        if ([model.target isEqualToString:@"activity.1"]) {
            cell.imageView.tintColor = [UIColor md_green];
        } else if ([model.target isEqualToString:@"activity.0"]) {
            cell.imageView.tintColor = [UIColor grayColor];
        }
    }
    

}

- (void)ax_tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self tableViewRowModelForIndexPath:indexPath];
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self tableViewRowModelForIndexPath:indexPath];
    if ([model.target containsString:@"chart."]) {
        return 200;
    } else {
        return -1;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.dataList.sections[section].headerTitle;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.dataList.sections[section].footerHeight;
}





#pragma mark - chart

/**
 总列数
 
 @return 总列数
 */
- (NSInteger)chartViewItemsCount:(AXChartView *)chartView{
    if ([chartView.title isEqualToString:@"步数详情"]) {
        if (self.queryViewUnit == BKQueryViewUnitDaily) {
            // 当天的步数详情
            return self.sport.lastObject.hourSteps.count + 1;
        } else {
            // 每天的步数
            if (self.queryViewUnit == BKQueryViewUnitYearly) {
                return 12;
            } else {
                return self.sport.count;
            }
        }
    } else if ([chartView.title isEqualToString:@"心率详情"]) {
        if (self.queryViewUnit == BKQueryViewUnitDaily) {
            // 当天的心率详情
            return self.hr.lastObject.minuteHR.count / 60 * hourHRCount + 1;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}


/**
 第index列的值
 
 @param index 列索引
 @return 第index列的值
 */
- (NSNumber *)chartView:(AXChartView *)chartView valueForIndex:(NSInteger)index{
    if ([chartView.title isEqualToString:@"步数详情"]) {
        if (self.queryViewUnit == BKQueryViewUnitDaily) {
            // 当天的步数详情
            if (index < self.sport.lastObject.hourSteps.count) {
                return self.sport.lastObject.hourSteps[index];
            } else {
                return @0;
            }
        } else {
            // 每天的步数
            return self.sport[index].steps;
        }
    } else if ([chartView.title isEqualToString:@"心率详情"]) {
        if (index*60/hourHRCount < self.hr.lastObject.minuteHR.count) {
            return self.hr.lastObject.minuteHR[index*60/hourHRCount];
        } else {
            return @0; // 最后一个0
        }
    } else {
        return @0;
    }
}


/**
 第index列的标题
 
 @param index 列索引
 @return 第index列的标题
 */
- (NSString *)chartView:(AXChartView *)chartView titleForIndex:(NSInteger)index{
    if ([chartView.title isEqualToString:@"步数详情"]) {
        if (self.queryViewUnit == BKQueryViewUnitWeekly) {
            return self.start.addDays(index).stringValue(@"EE");
        } else if (self.queryViewUnit == BKQueryViewUnitMonthly) {
            return self.start.addDays(index).stringValue(@"dd");
        } else if (self.queryViewUnit == BKQueryViewUnitYearly) {
            return self.start.addMonths(index).stringValue(@"M").append(@"月");
        } else {
            return NSStringFromNSInteger(index);
        }
    } else if ([chartView.title isEqualToString:@"心率详情"]) {
        return NSStringFromNSInteger(index/hourHRCount);
    } else {
        return @"";
    }
}

- (NSInteger)chartViewShowTitleForIndexWithSteps:(AXChartView *)chartView{
    if ([chartView.title isEqualToString:@"步数详情"]) {
        if (self.queryViewUnit == BKQueryViewUnitWeekly) {
            return 0;
        } else if (self.queryViewUnit == BKQueryViewUnitMonthly) {
            return 5;
        } else if (self.queryViewUnit == BKQueryViewUnitYearly) {
            return 1;
        } else {
            return 3;
        }
    } else if ([chartView.title isEqualToString:@"心率详情"]) {
        return hourHRCount * 3;// 3个小时
    } else {
        return 0;
    }
    
}

- (NSString *)chartView:(AXChartView *)chartView summaryText:(UILabel *)label{
    if ([chartView.title isEqualToString:@"步数详情"]) {
        return [NSString stringWithFormat:@"共走了%d步", [[self.sport valueForKeyPath:@"steps.@sum.doubleValue"] intValue]];
    } else if ([chartView.title isEqualToString:@"心率详情"]) {
        return @"";
    } else {
        return @"";
    }
}

- (NSNumber *)chartViewMaxValue:(AXChartView *)chartView{
    if ([chartView.title isEqualToString:@"步数详情"]) {
        if (self.queryViewUnit == BKQueryViewUnitDaily) {
            return @5000; // 每小时
        } else if (self.queryViewUnit == BKQueryViewUnitYearly) {
            return @(10000 * 20); // 每月
        } else {
            return @10000; // 每天
        }
    } else if ([chartView.title isEqualToString:@"心率详情"]) {
        return @200;
    } else {
        return @200;
    }
}



@end
