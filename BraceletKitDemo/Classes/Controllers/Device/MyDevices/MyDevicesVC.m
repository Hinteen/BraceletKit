//
//  MyDevicesVC.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 03/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "MyDevicesVC.h"
#import "MJRefresh.h"
#import "ScanTableViewCell.h"

@interface MyDevicesVC () <UITableViewDataSource, UITableViewDelegate, ScanTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView2;

@property (strong, nonatomic) NSMutableArray<BKDevice *> *devices;

@end

@implementation MyDevicesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的设备";
    self.devices = [NSMutableArray array];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= 49;
    self.tableView2 = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    [self.tableView2 registerNib:[UINib nibWithNibName:@"ScanTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ScanTableViewCell"];
    [self.view addSubview:self.tableView2];
    
    self.tableView2.rowHeight = 102;
    self.tableView2.sectionHeaderHeight = 16;
    self.tableView2.sectionFooterHeight = 0;
    
    __weak typeof(self) weakSelf = self;
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf reloadData];
    }];
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData{
    [self.devices removeAllObjects];
    [self.devices addObjectsFromArray:[BKDevice allMyDevices]];
    [self.tableView2 reloadData];
    [self.tableView2.mj_header endRefreshing];
}

- (CGRect)initContentFrame:(CGRect)frame{
    return frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.devices.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ScanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScanTableViewCell" forIndexPath:indexPath];
    cell.model = self.devices[indexPath.section];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [[BKServices sharedInstance].connector restoreOfflineDevice:self.devices[indexPath.section]];
    //    [self reloadData];
}

- (void)cell:(ScanTableViewCell *)cell didTappedSwitch:(UISwitch *)sender{
    if (sender.on) {
        [[BKServices sharedInstance].connector restoreOfflineDevice:cell.model];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else {
        [[BKServices sharedInstance].connector disConnectDevice];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

@end

