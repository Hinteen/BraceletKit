//
//  AXTableView.h
//  AXTableKit
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXTableModel.h"
#import "AXTableKitProtocol.h"


@interface AXTableView : UITableView <AXTableView>



/**
 获取数据

 @return 数据
 */
- (AXTableModelType *)dataList;

/**
 刷新tableView
 */
//- (void)reloadTableView;

/**
 重新获取数据源并刷新tableView
 */
//- (void)reloadDataSourceAndTableView;

/**
 根据指定的新数据源重新加载tableView
 
 @param dataList data source
 */
//- (void)reloadTableViewWithDataSource:(NSArray *)dataList;


/**
 删除某一行
 
 @param indexPath 索引
 */
- (void)ax_deleteCellWithIndexPath:(NSIndexPath *)indexPath;


/**
 根据索引获取组模型
 
 @param indexPath 索引
 @return 组模型
 */
- (AXTableSectionModelType *)ax_sectionModelForIndexPath:(NSIndexPath *)indexPath;

/**
 根据索引获取row模型
 
 @param indexPath 索引
 @return row模型
 */
- (AXTableRowModelType *)ax_rowModelForIndexPath:(NSIndexPath *)indexPath;


/**
 从bundle中加载数据源（需要与本类同名的json文件）

 @return 数据源
 */
- (NSObject<AXTableModel> *)ax_loadDataSourceFromBundle;

/**
 从指定路径加载数据源

 @param path 路径
 @return 数据源
 */
- (NSObject<AXTableModel> *)ax_loadDataSourceFromPath:(NSString *)path;

@end
