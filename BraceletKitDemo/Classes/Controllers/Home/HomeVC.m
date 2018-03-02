//
//  HomeVC.m
//  Hinteen
//
//  Created by xaoxuu on 07/09/2017.
//  Copyright © 2017 hinteen. All rights reserved.
//

#import "HomeVC.h"

#import "BKRefreshView.h"
#import "BKBatteryView.h"
#import "DeviceSettingTV.h"
#import <MJRefresh.h>
#import "BKSportQuery.h"
#import "BKSportData.h"
#import "BKHeartRateQuery.h"
#import "BKSleepQuery.h"
#import "BKSleepData.h"
#import <AXKit/StatusKit.h>
#import "BKChartTVC.h"

static NSString *reuseIdentifier = @"home table view cell";
static NSString *chartReuseIdentifier = @"home table view cell for chart";

// 每小时显示几条心率
static NSInteger hourHRCount = 12;

@interface HomeVC () <BKDeviceDelegate, BKDataObserver, UITableViewDataSource, UITableViewDelegate, AXChartViewDataSource, AXChartViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) BKSportQuery *sport;
@property (strong, nonatomic) BKHeartRateQuery *hr;
@property (strong, nonatomic) BKSleepQuery *sleep;


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    
    [self setupTableView];
    
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    [[BKServices sharedInstance] registerDataObserver:self];
    
    [self setupRefreshView];
    
    [self setupBatteryView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    if ([BKServices sharedInstance].connector.state != BKConnectStateConnected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[BKServices sharedInstance] unRegisterDeviceDelegate:self];
    [[BKServices sharedInstance] unRegisterDataObserver:self];
}

- (void)setupTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([BKDevice currentDevice]) {
            [[BKRefreshView sharedInstance] startAnimating];
            [[BKDevice currentDevice] requestUpdateBatteryCompletion:nil error:^(NSError * _Nonnull error) {
                [tableView.mj_header endRefreshing];
                [[BKRefreshView sharedInstance] stopAnimating];
            }];
            [[BKDevice currentDevice] requestUpdateAllHealthDataCompletion:nil error:^(NSError * _Nonnull error) {
                [tableView.mj_header endRefreshing];
                [[BKRefreshView sharedInstance] stopAnimating];
            }];
        } else {
            [tableView.mj_header endRefreshing];
            [[BKRefreshView sharedInstance] stopAnimating];
        }
    }];
    
}

- (void)setupRefreshView{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ax_itemWithCustomView:[BKRefreshView sharedInstance] action:^(UIBarButtonItem * _Nonnull sender) {
        [[BKRefreshView sharedInstance] startAnimating];
        [[BKDevice currentDevice] requestUpdateBatteryCompletion:nil error:nil];
        [[BKDevice currentDevice] requestUpdateAllHealthDataCompletion:nil error:nil];
    }];
}
- (void)setupBatteryView{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithCustomView:[BKBatteryView sharedInstance] action:^(UIBarButtonItem * _Nonnull sender) {
        
    }];
}


/**
 更新了电池信息
 
 @param battery 电池电量
 */
- (void)deviceDidUpdateBattery:(NSInteger)battery{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[BKBatteryView sharedInstance] updateBatteryPercent:(CGFloat)battery / 100.0f];
    });
}

- (void)deviceDidSynchronizing:(BOOL)synchronizing{
    if (!synchronizing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }
}

- (void)dataDidUpdated:(__kindof BKData *)data{
    [self reloadData];
}

- (void)reloadData{
    self.sport = [BKSportQuery queryDailySummaryWithDate:[NSDate date]];
    self.hr = [BKHeartRateQuery queryDailySummaryWithDate:[NSDate date]];
    self.sleep = [BKSleepQuery queryDailySummaryWithDate:[NSDate date]];
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // 今日概览、分段运动、心率数据、睡眠数据
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        if (self.sport) {
            return self.sport.items.count;
        } else {
            return 0;
        }
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        if (self.sleep) {
            return self.sleep.items.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        BKChartTVC *cell = (BKChartTVC *)[tableView dequeueReusableCellWithIdentifier:chartReuseIdentifier];
        if (!cell) {
            cell = [[BKChartTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartReuseIdentifier];
        }
        cell.chartView.dataSource = self;
        cell.chartView.delegate = self;
        cell.chartView.title = @"心率详情";
        [cell.chartView reloadData];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.tintColor = axThemeManager.color.theme;
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.imageView.image = UIImageNamed(@"icon_foot");
            cell.imageView.tintColor = [UIColor md_blue];
            cell.textLabel.text = @"步数";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d steps", self.sport.steps.intValue];
        } else if (indexPath.row == 1) {
            cell.imageView.image = UIImageNamed(@"icon_distance");
            cell.imageView.tintColor = [UIColor md_amber];
            cell.textLabel.text = @"距离";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f km", self.sport.distance.doubleValue / 1000.0f];
        } else if (indexPath.row == 2) {
            cell.imageView.image = UIImageNamed(@"icon_calorie");
            cell.imageView.tintColor = [UIColor md_red];
            cell.textLabel.text = @"卡路里";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f cal", self.sport.calorie.doubleValue];
        } else if (indexPath.row == 3) {
            cell.imageView.image = UIImageNamed(@"icon_time");
            cell.imageView.tintColor = [UIColor md_green];
            cell.textLabel.text = @"活动时长";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d min", self.sport.activity.intValue];
        } else if (indexPath.row == 4) {
            cell.imageView.image = UIImageNamed(@"icon_sleep");
            cell.imageView.tintColor = [UIColor md_deepPurple];
            cell.textLabel.text = @"睡眠时长";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%dh %dmin", (int)self.sleep.duration/60, (int)self.sleep.duration%60];
        }
    } else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (self.sport.items[indexPath.row].steps >= 1000) {
            cell.imageView.image = UIImageNamed(@"icon_run");
            cell.imageView.tintColor = [UIColor md_green];
        } else {
            cell.imageView.image = UIImageNamed(@"icon_walk");
            cell.imageView.tintColor = [UIColor grayColor];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", self.sport.items[indexPath.row].start.stringValue(@"HH:mm"), self.sport.items[indexPath.row].end.stringValue(@"HH:mm")];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d steps", (int)self.sport.items[indexPath.row].steps];
    } else if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = nil;
        cell.textLabel.text = @"心率图表";
        cell.detailTextLabel.text = @"";
    } else if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.imageView.image = nil;
        cell.textLabel.text = [NSString stringWithFormat:@"(type: %d) %@ - %@", (int)self.sleep.items[indexPath.row].sleepType, self.sleep.items[indexPath.row].start.stringValue(@"HH:mm"), self.sleep.items[indexPath.row].end.stringValue(@"HH:mm")];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d min", (int)self.sleep.items[indexPath.row].duration];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"今日概览";
    } else if (section == 1) {
        return @"活动记录";
    } else if (section == 2) {
        return @"";
    } else if (section == 3) {
        return @"睡眠记录";
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 200;
    } else {
        return -1;
    }
}

#pragma mark - chart

/**
 总列数
 
 @return 总列数
 */
- (NSInteger)chartViewItemsCount:(AXChartView *)chartView{
    return self.hr.minuteHR.count / 60 * hourHRCount + 1;
}


/**
 第index列的值
 
 @param index 列索引
 @return 第index列的值
 */
- (NSNumber *)chartView:(AXChartView *)chartView valueForIndex:(NSInteger)index{
    if (index*60/hourHRCount < self.hr.minuteHR.count) {
        return self.hr.minuteHR[index*60/hourHRCount];
    } else {
        return @0; // 最后一个0
    }
//    return @(arc4random_uniform(80) + 50);
}


/**
 第index列的标题
 
 @param index 列索引
 @return 第index列的标题
 */
- (NSString *)chartView:(AXChartView *)chartView titleForIndex:(NSInteger)index{
    return NSStringFromNSInteger(index/hourHRCount);
}

- (NSInteger)chartViewShowTitleForIndexWithSteps:(AXChartView *)chartView{
    return hourHRCount * 3;// 3个小时
}

- (NSString *)chartView:(AXChartView *)chartView summaryText:(UILabel *)label{
    return @"";
}

- (NSNumber *)chartViewMaxValue:(AXChartView *)chartView{
    return @200;
}


@end
