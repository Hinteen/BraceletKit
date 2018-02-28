//
//  UserInfoTV.m
//  BraceletKitDemo
//
//  Created by xaoxuu on 27/02/2018.
//  Copyright © 2018 xaoxuu. All rights reserved.
//

#import "UserInfoTV.h"
#import "BKGenderPicker.h"
#import "BKBirthdayPicker.h"
#import "BKHeightPicker.h"
#import "BKWeightPicker.h"


@interface UserInfoTV ()


@end

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
            row.target = @"rename.username";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"邮箱";
            row.detail = user.email;
            row.target = @"rename.email";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"手机";
            row.detail = user.phone;
            row.target = @"rename.phone";
        }];
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
            row.target = @"birthday";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"身高";
            row.detail = [NSString stringWithFormat:@"%.0f cm", user.height];
            row.target = @"height";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"体重";
            row.detail = [NSString stringWithFormat:@"%.1f kg", user.weight];
            row.target = @"weight";
        }];
        
    }];
    
    dataSource(dataList);
    
}

- (void)ax_tableViewDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *model = [self tableViewRowModelForIndexPath:indexPath];
    
    if ([model.target containsString:@"rename"]) {
        [UIAlertController ax_showAlertWithTitle:[NSString stringWithFormat:@"修改%@", model.title] message:[NSString stringWithFormat:@"请输入新的%@", model.title] actions:^(UIAlertController * _Nonnull alert) {
            __block UITextField *tf;
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                tf = textField;
                if ([model.target containsString:@"phone"]) {
                    textField.keyboardType = UIKeyboardTypePhonePad;
                }
                textField.placeholder = model.detail;
                [textField ax_addEditingEndOnExitHandler:^(__kindof UITextField * _Nonnull sender) {
                    [[BKUser currentUser] transaction:^(BKUser *user) {
                        if ([model.target containsString:@"username"]) {
                            user.name = tf.text;
                        } else if ([model.target containsString:@"email"]) {
                            user.email = tf.text;
                        } else if ([model.target containsString:@"phone"]) {
                            user.phone = tf.text;
                        }
                    }];
                }];
            }];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                if (tf) {
                    [tf endEditing:YES];
                    [[BKUser currentUser] transaction:^(BKUser *user) {
                        if ([model.target containsString:@"username"]) {
                            user.name = tf.text;
                        } else if ([model.target containsString:@"email"]) {
                            user.email = tf.text;
                        } else if ([model.target containsString:@"phone"]) {
                            user.phone = tf.text;
                        }
                    }];
                }
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.target isEqualToString:@"gender"]) {
        [UIAlertController ax_showActionSheetWithTitle:@"修改性别" message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            BKGenderPicker *picker = [[BKGenderPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [[BKUser currentUser] transaction:^(BKUser *user) {
                    user.gender = (BKGender)[picker selectedRowInComponent:0];
                }];
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.target isEqualToString:@"birthday"]) {
        [UIAlertController ax_showActionSheetWithTitle:@"设置生日" message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            BKBirthdayPicker *picker = [[BKBirthdayPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [[BKUser currentUser] transaction:^(BKUser *user) {
                    user.birthday = picker.date;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.target isEqualToString:@"height"]) {
        [UIAlertController ax_showActionSheetWithTitle:@"设置身高" message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            BKHeightPicker *picker = [[BKHeightPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [[BKUser currentUser] transaction:^(BKUser *user) {
                    user.height = picker.value.doubleValue;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.target isEqualToString:@"weight"]) {
        [UIAlertController ax_showActionSheetWithTitle:@"设置体重" message:@"\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            BKWeightPicker *picker = [[BKWeightPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [[BKUser currentUser] transaction:^(BKUser *user) {
                    user.weight = picker.value.doubleValue;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    }
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.dataList.sections[section].headerTitle;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.dataList.sections[section].footerHeight;
}




@end
