//
//  AXTableViewCell.m
//  AXTableKit
//
//  Created by xaoxuu on 27/10/2017.
//  Copyright © 2017 xaoxuu. All rights reserved.
//

#import "AXTableViewCell.h"
#import "UIThemeManager.h"
#import "NSString+AXExtension.h"

@interface AXTableViewCell ()


@end


@implementation AXTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self _init];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self _init];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _init];
    }
    return self;
}

- (void)_init{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setModel:(NSObject<AXTableRowModel> *)model{
    _model = model;
    self.textLabel.font = [self fontForTitle];
    self.detailTextLabel.font = [self fontForDetail];
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.detail;
    if (model.icon.isURLString) {
        if ([self.delegate respondsToSelector:@selector(ax_tableViewCell:needsLoadWebImageFromPath:forImageView:)]) {
            [self.delegate ax_tableViewCell:self needsLoadWebImageFromPath:model.icon forImageView:self.imageView];
        }
    } else {
        self.imageView.image = [self imageWithPath:model.icon];
    }
    if ([model respondsToSelector:@selector(accessoryType)]) {
        self.accessoryType = model.accessoryType;
    }
    
}

- (UIFont *)fontForTitle{
    return [UIThemeManager sharedInstance].font.customNormal;
}
- (UIFont *)fontForDetail{
    return [UIThemeManager sharedInstance].font.customSmall;
}

- (UIImage *)imageWithPath:(NSString *)path{
    UIImage *image;
    image = [UIImage imageNamed:path];
    if (!image) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    }
    if (!image) {
#if DEBUG
        NSLog(@"本地找不到图片");
#endif
    }
    return image;
}

@end
