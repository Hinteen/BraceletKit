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
#import <AXKit/FeedbackKit.h>
#import <AXKit/StatusKit.h>


@interface UserInfoTV ()


@end

@implementation UserInfoTV


- (void)ax_tableViewDataSource:(void (^)(AXTableModelType *))dataSource{
    BKUser *user = [BKUser currentUser];
    
    AXTableModel *dataList = [[AXTableModel alloc] init];
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"用户信息";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"用户名";
            row.detail = user.name;
            row.target = @"rename.username";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"邮箱";
            row.detail = user.email;
            row.target = @"rename.email";
            row.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    [dataList addSection:^(AXTableSectionModel *section) {
        section.headerTitle = @"应用信息";
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"版本";
            row.detail = [NSString stringWithFormat:@"%@ (%@)", [NSBundle ax_appVersion], [NSBundle ax_appBuild]];
            row.target = @"";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"构建日期";
            NSString *build = [NSBundle ax_appBuild];
            build = [build substringToIndex:build.length-1];
            row.detail = [NSDate dateWithString:build format:@"Mdd"].stringValue(@"MM-dd");
            row.target = @"";
        }];
        [section addRow:^(AXTableRowModel *row) {
            row.title = @"反馈";
            row.detail = @"发送邮件";
            row.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            row.target = @"feedback";
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
                tf.returnKeyType = UIReturnKeyDone;
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
        [UIAlertController ax_showActionSheetWithTitle:@"修改性别" message:@"\n\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
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
        [UIAlertController ax_showActionSheetWithTitle:@"设置生日" message:@"\n\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
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
        [UIAlertController ax_showActionSheetWithTitle:@"设置身高" message:@"\n\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
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
        [UIAlertController ax_showActionSheetWithTitle:@"设置体重" message:@"\n\n\n\n\n\n" actions:^(UIAlertController * _Nonnull alert) {
            BKWeightPicker *picker = [[BKWeightPicker alloc] initWithFrame:CGRectMake(8, kNavBarHeight, kScreenW - 10 * 2 - 8 * 2, 100)];
            [alert.view addSubview:picker];
            [alert ax_addDefaultActionWithTitle:nil handler:^(UIAlertAction * _Nonnull sender) {
                [[BKUser currentUser] transaction:^(BKUser *user) {
                    user.weight = picker.value.doubleValue;
                }];
            }];
            [alert ax_addCancelAction];
        }];
    } else if ([model.target isEqualToString:@"feedback"]) {
        [[EmailManager sharedInstance] sendEmail:^(MFMailComposeViewController * _Nonnull mailCompose) {
            mailCompose.navigationBar.tintColor = [UIColor whiteColor];
            [mailCompose setToRecipients:@[@"me@xaoxuu.com"]];
            [mailCompose setSubject:@"Feedback of BraceletKit"];
            
            [mailCompose setMessageBody:[NSString stringWithFormat:@"\n\n\n\napp version: %@ (%@)", [NSBundle ax_appVersion], [NSBundle ax_appBuild]] isHTML:NO];
            
            // db
            NSString *path = @"com.xaoxuu.braceletkit.db".docPath;
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                [mailCompose addAttachmentData:data mimeType:@"" fileName:path.lastPathComponent];
            }
            
            // 最近7天的log
            NSArray<NSString *> *logs = [AXCachedLog getLatestCachedLogPathWithDateCount:7];
            [logs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *data = [NSData dataWithContentsOfFile:obj];
                if (data) {
                    [mailCompose addAttachmentData:data mimeType:@"" fileName:obj.lastPathComponent];
                }
            }];
            
            
            
        } completion:^(MFMailComposeResult result) {
            if (result == MFMailComposeResultSent) {
                [AXStatusBar showStatusBarMessage:@"反馈邮件发送成功！" textColor:[UIColor whiteColor] backgroundColor:[UIColor md_green] duration:3];
            }
        } fail:^(NSError * _Nonnull error) {
            [AXStatusBar showStatusBarMessage:error.localizedDescription textColor:[UIColor whiteColor] backgroundColor:[UIColor md_red] duration:5];
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
