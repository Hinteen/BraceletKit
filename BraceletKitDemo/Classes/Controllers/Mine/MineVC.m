//
//  MineVC.m
//  Hinteen
//
//  Created by xaoxuu on 07/09/2017.
//  Copyright © 2017 hinteen. All rights reserved.
//

#import "MineVC.h"
#import "UserInfoTV.h"


@interface MineVC () <BKDataObserver>

@property (strong, nonatomic) UserInfoTV *tableView;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    [self setupTableView];
    
    [[BKServices sharedInstance] registerDataObserver:self];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[BKServices sharedInstance] unRegisterDataObserver:self];
}


- (void)setupTableView{
    
    self.tableView = [[UserInfoTV alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
}

- (void)userDidUpdated:(BKUser *)user{
    [self.tableView reloadDataSourceAndRefreshTableView];
}


@end
