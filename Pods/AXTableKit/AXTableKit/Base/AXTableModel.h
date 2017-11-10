//
//  AXTableModel.h
//  AXTableKit
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXTableKitProtocol.h"

@class AXTableSectionModel,AXTableRowModel;

@interface AXTableModel : NSObject <AXTableModel>

/**
 TableView的标题
 */
@property (copy, nonatomic) NSString *title;

/**
 header title
 */
@property (copy, nonatomic) NSString *headerTitle;

/**
 header height
 */
@property (assign, nonatomic) CGFloat headerHeight;

/**
 footer title
 */
@property (copy, nonatomic) NSString *footerTitle;

/**
 footer height
 */
@property (assign, nonatomic) CGFloat footerHeight;

/**
 TableView的sections
 */
@property (strong, nonatomic) NSMutableArray<__kindof AXTableSectionModel *> *sections;


/**
 添加一个section

 @param section section
 */
- (void)addSection:(void (^)(AXTableSectionModel *section))section;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end


@interface AXTableSectionModel : NSObject <AXTableSectionModel>

/**
 header title
 */
@property (copy, nonatomic) NSString *headerTitle;

/**
 header height
 */
@property (assign, nonatomic) CGFloat headerHeight;

/**
 footer title
 */
@property (copy, nonatomic) NSString *footerTitle;

/**
 footer height
 */
@property (assign, nonatomic) CGFloat footerHeight;

/**
 row height 行高
 */
@property (assign, nonatomic) CGFloat rowHeight;

/**
 rows
 */
@property (strong, nonatomic) NSMutableArray<__kindof AXTableRowModel *> *rows;

/**
 添加一个row

 @param row row
 */
- (void)addRow:(void (^)(AXTableRowModel *row))row;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end


@interface AXTableRowModel : NSObject <AXTableRowModel>

/**
 title
 */
@property (copy, nonatomic) NSString *title;

/**
 detail
 */
@property (copy, nonatomic) NSString *detail;

/**
 icon path
 */
@property (copy, nonatomic) NSString *icon;

/**
 要跳转的地方，可以是ViewController的名字，也可以是一个网址
 */
@property (copy, nonatomic) NSString *target;

/**
 row height
 */
@property (assign, nonatomic) CGFloat rowHeight;


/**
 accessory
 */
@property (assign, nonatomic) UITableViewCellAccessoryType accessoryType;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
