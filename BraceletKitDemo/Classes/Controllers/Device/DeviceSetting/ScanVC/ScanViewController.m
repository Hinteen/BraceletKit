//
//  ScanViewController.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 26/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "ScanViewController.h"
#import <BraceletKit/BraceletKit.h>
#import "ScanTableViewCell.h"
#import "MJRefresh.h"
#import "BKServices.h"

@interface ScanViewController () <UITableViewDataSource, UITableViewDelegate, BKScanDelegate, ScanTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView2;

@property (strong, nonatomic) NSMutableArray<BKDevice *> *devices;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"扫描设备";
    self.devices = [NSMutableArray array];
    
    CGRect frame = self.view.bounds;
//    frame.size.height -= 49 + 64;
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
        [weakSelf.devices removeAllObjects];
        [[BKServices sharedInstance].scanner stopScan];
        [[BKServices sharedInstance].scanner scanDevice];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView2.mj_header endRefreshing];
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.devices removeAllObjects];
    
}

- (CGRect)initContentFrame:(CGRect)frame{
    frame.size.height -= 64;
    return frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[BKServices sharedInstance] registerScanDelegate:self];
    [[BKServices sharedInstance].scanner scanDevice];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.devices removeAllObjects];
    [[BKServices sharedInstance].scanner stopScan];
    [[BKServices sharedInstance] unRegisterScanDelegate:self];
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
}

- (void)scannerDidDiscoverDevice:(BKDevice *)device{
    [self.devices addObject:device];
    dispatch_async(dispatch_get_main_queue(), ^{
        // @xaoxuu: in main queue
        [self.tableView2 reloadData];
    });
}

- (void)cell:(ScanTableViewCell *)cell didTappedSwitch:(UISwitch *)sender{
    if (sender.on) {
        [[BKServices sharedInstance].connector connectDevice:cell.model];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else {
        [[BKServices sharedInstance].connector disConnectDevice];
    }
}

@end
