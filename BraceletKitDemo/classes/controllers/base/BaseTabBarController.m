//
//  BaseTabBarController.m
//  AXKit
//
//  Created by xaoxuu on 29/04/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavController.h"
#import "DefaultViewController.h"
// =============== 第三方库
#import <YYKit/YYKit.h>
#import <AXKit/AXKit.h>

// =============== 内部
// @xaoxuu: 常量
#import "HTConst.h"
#import "HTMacros.h"
#import "HTStrings.h"
// @xaoxuu: 服务层
#import "ServicesLayer.h"


@interface BaseTabBarController ()

// @xaoxuu: child controllers
@property (strong, nonatomic) NSArray<NSDictionary *> *controllers;

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    for (NSDictionary *dict in self.controllers) {
        
        UIViewController *vc = UIViewControllerFromString(dict[@"vc"]) ?: services.app.defaultVC;
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
        [self setupChlidController:vc title:dict[@"title"] image:dict[@"icon"] selectedImage:dict[@"icon_sel"]];
    }
    
    [self.tabBar.layer ax_shadow:LayerShadowUpLight];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tabBar ax_hideSeparator];
    [services.app applyTheme];
}

- (NSArray<NSDictionary *> *)controllers{
    if (!_controllers) {
        _controllers = @"tabbar_controllers.json".mainBundlePath.readJson();
    }
    return _controllers;
}


// setup child controllers
- (void)setupChlidController:(UIViewController * __nonnull)vc title:(NSString * __nullable)title image:(NSString * __nonnull)image selectedImage:(NSString * __nullable)selectedImage {
    if (vc) {
        vc.title = NSLocalizedString(title, nil);
        if (image.length) {
            if (image.isURLString) {
                // @xaoxuu: 网络图片
                [[[UIImageView alloc] init] setImageWithURL:image.absoluteURL placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    vc.tabBarItem.image = image;
                }];
                
            } else {
                // @xaoxuu: 本地图片
                vc.tabBarItem.image = [UIImage imageNamed:image];
            }
            if (selectedImage) {
                if (image.isURLString) {
                    // @xaoxuu: 网络图片
                    [[[UIImageView alloc] init] setImageWithURL:selectedImage.absoluteURL placeholder:nil options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                        vc.tabBarItem.selectedImage = image;
                    }];
                    
                } else {
                    // @xaoxuu: 本地图片
                    vc.tabBarItem.selectedImage = selectedImage.image;
                }
            }
        }
    }
}



@end
