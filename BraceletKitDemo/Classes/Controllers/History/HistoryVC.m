//
//  HistoryVC.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 28/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "HistoryVC.h"
#import "BKQueryDateControl.h"
#import "HistoryTV.h"

@interface HistoryVC () <BKQueryDateControlDelegate>

@property (strong, nonatomic) BKQueryDateControl *indexControl;

@property (strong, nonatomic) HistoryTV *tableView;

@end

@implementation HistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    
    [self setupTableView];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    BKQueryDateControl *indexControl = [[BKQueryDateControl alloc] initWithDelegate:self];
    indexControl.bottom = self.view.height - 16;
//    indexControl.right = self.view.width - 16;
    indexControl.centerX = 0.5 * self.view.width;
    [self.view addSubview:indexControl];
    self.indexControl = indexControl;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.indexControl refreshQueryDate];
}


- (void)setupTableView{
    
    self.tableView = [[HistoryTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
}


- (void)queryDateDidChanged:(BKQueryViewUnit)queryUnit start:(NSDate *)start end:(NSDate *)end{
    if (queryUnit == BKQueryViewUnitWeekly) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@年 %@ ~ %@", start.stringValue(@"yyyy"), start.stringValue(@"M月d日"), end.addDays(-1).stringValue(@"M月d日")];
    } else if (queryUnit == BKQueryViewUnitMonthly) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@年%@月", start.stringValue(@"yyyy"), start.stringValue(@"M")];
    } else if (queryUnit == BKQueryViewUnitYearly) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@年", start.stringValue(@"yyyy")];
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"%@", start.stringValue(@"yyyy-MM-dd")];
    }
    self.tableView.queryViewUnit = queryUnit;
    self.tableView.start = start;
    self.tableView.end = end;
    [self.tableView reloadDataSourceAndRefreshTableView];
}

@end
