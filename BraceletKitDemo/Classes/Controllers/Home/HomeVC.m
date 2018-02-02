//
//  HomeVC.m
//  Hinteen
//
//  Created by xaoxuu on 07/09/2017.
//  Copyright © 2017 hinteen. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableView.h"

#import "DeviceSettingTV.h"



static inline CGSize contentSize(){
    return CGSizeMake(kScreenW, kScreenH - kTopBarHeight - kTabBarHeight);
}

@interface HomeVC () <BKDeviceDelegate>


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.width = kScreenW;
    self.view.height -= kTabBarHeight;
    
    [[BKServices sharedInstance] registerDeviceDelegate:self];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem ax_itemWithImageName:@"battery" action:^(UIBarButtonItem * _Nonnull sender) {
        sender.image = UIImageNamed(@"refresh");
        [[BKDevice currentDevice] refreshBattery];
        [[BKDevice currentDevice] syncAllDataCompletion:nil error:nil];
    }];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadDataSourceAndRefreshTableView];
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
}

- (AXTableViewType *)installTableView{
    return [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, contentSize().width, contentSize().height) style:UITableViewStyleGrouped];
}

/**
 更新了电池信息
 
 @param battery 电池电量
 */
- (void)deviceDidUpdateBattery:(NSInteger)battery{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.image = nil;
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"%d%%", (int)battery];
    });
}


@end
