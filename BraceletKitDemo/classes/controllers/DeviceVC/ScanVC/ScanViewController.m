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


@interface ScanViewController () <UITableViewDataSource, UITableViewDelegate, BraceletManager>

@property (strong, nonatomic) UITableView *tableView2;

@property (strong, nonatomic) NSMutableArray<ZeronerBlePeripheral *> *devices;



@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.devices = [NSMutableArray array];
    
    CGRect frame = self.view.bounds;
//    frame.size.height -= 49 + 64;
    self.tableView2 = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView2.dataSource = self;
    self.tableView2.delegate = self;
    [self.tableView2 registerNib:[UINib nibWithNibName:@"ScanTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ScanTableViewCell"];
    [self.view addSubview:self.tableView2];
    
    self.tableView2.rowHeight = 136;
    self.tableView2.sectionHeaderHeight = 16;
    self.tableView2.sectionFooterHeight = 0;
    
    __weak typeof(self) weakSelf = self;
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[BLELib3 shareInstance] stopScan];
        [weakSelf.devices removeAllObjects];
        [[BraceletManager sharedInstance] scanDevice];
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
    frame.size.height -= 49 + 64;
    return frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[BraceletManager sharedInstance] registerDelegate:self];
    [[BraceletManager sharedInstance] scanDevice];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.devices removeAllObjects];
    [[BLELib3 shareInstance] stopScan];
    [[BraceletManager sharedInstance] unRegisterDelegate:self];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)braceletDidDiscoverDeviceWithMAC:(ZeronerBlePeripheral *)iwDevice{
    [self.devices addObject:iwDevice];
    dispatch_async(dispatch_get_main_queue(), ^{
        // @xaoxuu: in main queue
        [self.tableView2 reloadData];
    });
}

@end
