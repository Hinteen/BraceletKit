//
//  UserInfoTV.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 27/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "UserInfoTV.h"

@implementation UserInfoTV


- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    BKUser *user = [BKUser currentUser];
    
    AXTableModel *dataList = [[AXTableModel alloc] init];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"基本信息";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"用户名";
            if (user.name.length) {
                row.detail = user.name;
            } else {
                row.detail = @"未知";
            }
            row.target = @"";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"邮箱";
            row.detail = user.email;
            row.target = @"";
        }];
        if (user.phone.length) {
            [section addRow:^(AXTableRowModel *row) {
                row.title = @"手机";
                row.detail = user.phone;
                row.target = @"";
            }];
        }
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"性别";
            switch (user.gender) {
                case BKGenderUnknown:
                    row.detail = @"未知";
                    break;
                case BKGenderMale:
                    row.detail = @"男";
                    break;
                case BKGenderFemale:
                    row.detail = @"女";
                    break;
            }
            row.target = @"gender";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"生日";
            row.detail = user.birthday.stringValue(@"yyyy-MM-dd");
            row.target = @"";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"身高";
            row.detail = [NSString stringWithFormat:@"%.0f cm", user.height];
            row.target = @"";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"体重";
            row.detail = [NSString stringWithFormat:@"%.0f cm", user.weight];
            row.target = @"";
        }];
        
    }];
    
    dataSource(dataList);
    
}

- (void)ax_tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.dataList.sections[section].headerTitle;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.dataList.sections[section].footerHeight;
}


@end
