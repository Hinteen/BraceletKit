//
//  AXTableView.m
//  AXTableKit
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "AXTableView.h"
#import "AXTableViewCell.h"
#import "UIView+AXExtension.h"
#import "NSString+AXExtension.h"
#import "UIApplication+AXExtension.h"
#import "ThemeKit.h"

@interface AXTableView () <UIScrollViewDelegate>



// @xaoxuu: list
@property (strong, nonatomic) NSObject<AXTableModel> *dataList;

@property (copy, nonatomic) NSString *modelClassName;

/**
 复用id，如果自定义cell，需要将此值设置为cell的NibName
 */
@property (copy, nonatomic) NSString *reuseIdentifier;

@end


@implementation AXTableView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [self initWithFrame:frame style:UITableViewStyleGrouped]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        
        [self setupData];
        
        
        [self setupTableView];
        
        [self setupDelegates];
        
        
        // load finished
        if ([self respondsToSelector:@selector(ax_tableViewDidLoadFinished:)]) {
            [self ax_tableViewDidLoadFinished:self];
        }
    }
    return self;
    
}



- (void)setupData{
    self.reuseIdentifier = NSStringFromClass(AXTableViewCell.class);
    self.modelClassName = NSStringFromClass(AXTableModel.class);
    
}

- (void)setupTableView{
    // @xaoxuu: 注册复用池
    if (self.reuseIdentifier.length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.reuseIdentifier ofType:@"nib"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [self registerNib:[UINib nibWithNibName:self.reuseIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:self.reuseIdentifier];
        } else {
            
        }
    }
    self.dataSource = self;
    self.delegate = self;
    // @xaoxuu: 高度
    self.estimatedRowHeight = 44;
    self.estimatedSectionHeaderHeight = 0;
    self.rowHeight = 44;
    
    
    
    
}

- (void)setupDelegates{
    // @xaoxuu: 设置table view
    
    
}


#pragma mark - func

- (void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        // @xaoxuu: in main queue
        
        [super reloadData];
    });
}

- (void)reloadDataSourceAndRefreshTableView{
    if ([self respondsToSelector:@selector(ax_tableView:dataSource:)]) {
        [self ax_tableView:self dataSource:^(AXTableModelType *dataSource) {
            _dataList = dataSource;
            [self reloadData];
        }];
    }
}

- (AXTableSectionModelType *)modelForSection:(NSInteger)section{
    return self.dataList.sections[section];
}
- (AXTableRowModelType *)modelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataList.sections[indexPath.section].rows[indexPath.row];
}



- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath{
    [self.dataList.sections[indexPath.section].rows removeObjectAtIndex:indexPath.row];
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (AXTableModelType *)loadDataSourceFromBundle{
    NSString *path = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@".json"];
    return [self loadDataSourceFromPath:path];
}


- (AXTableModelType *)loadDataSourceFromPath:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!dict) {
#if DEBUG
        if (error) {
            NSLog(@"load data source error: %@", error.description);
        }
//        NSAssert(NO, error.description);
#endif
        return nil;
    }
    
    NSObject<AXTableModel> *model = [NSClassFromString(self.modelClassName) modelWithDictionary:dict];
    return model;
}

- (UITableViewCell<AXTableViewCell> *)cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (AXTableViewCellType *)[super cellForRowAtIndexPath:indexPath];
}
#pragma mark - priv

- (NSObject<AXTableModel> *)dataList{
    if (!_dataList) {
        if ([self respondsToSelector:@selector(ax_tableViewPreloadDataSource)]) {
            _dataList = [self ax_tableViewPreloadDataSource];
        }
        [self reloadDataSourceAndRefreshTableView];
    }
    return _dataList;
}


#pragma mark - data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.sections[section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    AXTableSectionModelType *section = self.dataList.sections[indexPath.section];
    AXTableRowModelType *model = section.rows[indexPath.row];
    AXTableViewCellType *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    if (!cell) {
        cell = [[AXTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:self.reuseIdentifier];
    }
    if (cell.frame.size.width != self.frame.size.width) {
        CGRect frame = cell.frame;
        frame.size.width = self.frame.size.width;
        cell.frame = frame;
    }
    
    
    // @xaoxuu: 即将设置模型
    if ([self respondsToSelector:@selector(ax_tableView:willSetModel:forRowAtIndexPath:)]) {
        [self ax_tableView:self willSetModel:model forRowAtIndexPath:indexPath];
    }
    // @xaoxuu: 设置模型
    if ([cell respondsToSelector:@selector(setModel:)]) {
        cell.model = model;
    }
    // @xaoxuu: 已经设置模型
    if ([self respondsToSelector:@selector(ax_tableView:didSetModelForCell:atIndexPath:)]) {
        [self ax_tableView:self didSetModelForCell:cell atIndexPath:indexPath];
    }
    
    
    
    
    return cell;
}


#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    AXTableRowModelType *model = self.dataList.sections[section].rows[row];
    if (!model) {
        return;
    }
    // @xaoxuu: selection action
    if ([self respondsToSelector:@selector(ax_tableView:didSelectedRowAtIndexPath:model:)]) {
        [self ax_tableView:self didSelectedRowAtIndexPath:indexPath model:model];
        return;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *row = self.dataList.sections[indexPath.section].rows[indexPath.row];
    if ([row respondsToSelector:@selector(rowHeight)]) {
        return row.rowHeight;
    } else {
        return -1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AXTableRowModelType *row = self.dataList.sections[indexPath.section].rows[indexPath.row];
    if ([row respondsToSelector:@selector(rowHeight)]) {
        return row.rowHeight;
    } else {
        return -1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    AXTableSectionModelType *sec = self.dataList.sections[section];
    if ([sec respondsToSelector:@selector(headerTitle)]) {
        return sec.headerTitle;
    } else {
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    AXTableSectionModelType *sec = self.dataList.sections[section];
    if ([sec respondsToSelector:@selector(footerTitle)]) {
        return sec.footerTitle;
    } else {
        return @"";
    }
}


- (void)_indexPath:(NSIndexPath *)indexPath tryPush:(UIViewController *)targetVC withModel:(AXTableRowModelType *)model{
    void (^block_push)(void) = ^{
        if ([self respondsToSelector:@selector(ax_tableView:willPushViewController:fromRowAtIndexPath:)]) {
            [self ax_tableView:self willPushViewController:targetVC fromRowAtIndexPath:indexPath];
        }
        [self.controller.navigationController pushViewController:targetVC animated:YES];
    };
    block_push();
}

#pragma mark - AXTableKit的协议默认实现

- (NSObject<AXTableModel> *)ax_tableViewPreloadDataSource{
    return [self loadDataSourceFromBundle];
}


- (void)ax_tableView:(AXTableViewType *)tableView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath model:(AXTableRowModelType *)model{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[[NSClassFromString(model.target) class] alloc] init];
    if (vc) {
        vc.title = NSLocalizedString(model.title, nil);
        [self _indexPath:indexPath tryPush:vc withModel:model];
    } else if (model.target.isURLString) {
        [UIApplication ax_presentSafariViewControllerWithURL:model.target.absoluteURL fromViewController:self.controller];
    }
}


@end
