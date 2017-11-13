//
//  AXTabBarController.m
//  AXKit
//
//  Created by xaoxuu on 13/11/2017.
//  Copyright © 2017 Titan Studio. All rights reserved.
//

#import "AXTabBarController.h"

static inline UIViewController *UIViewControllerFromString(NSString *name){
    return [[[NSClassFromString(name) class] alloc] init];
}

static inline UIImage *UIImageFromString(NSString *name){
    UIImage *image = [UIImage imageNamed:name];
    if (!image) {
        NSData *data = [NSData dataWithContentsOfFile:name];
        image = [UIImage imageWithData:data];
    }
    return image;
}

@interface AXTabBarController ()

// @xaoxuu: child controllers
@property (strong, nonatomic) NSArray<NSDictionary *> *controllers;

@end

@implementation AXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.controllers enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = UIViewControllerFromString(obj[self.configurationKeyForViewControllerName]);
        if (vc) {
            __kindof UINavigationController *nav = [[NSClassFromString(self.classNameForBaseNavigationController) alloc] initWithRootViewController:vc];
            [self addChildViewController:nav];
            [self setupChlidController:vc
                                 title:obj[self.configurationKeyForViewControllerTitle]
                                 image:obj[self.configurationKeyForTabBarIconName]
                         selectedImage:obj[self.configurationKeyForTabBarSelectedIconName]];
        } else {
#if DEBUG
            NSLog(@"The view controller named '%@' is missing.", obj[self.configurationKeyForViewControllerName]);
#endif
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<NSDictionary *> *)controllers{
    if (!_controllers.count) {
        NSData *data = [NSData dataWithContentsOfFile:self.configurationFilePath];
        if (data) {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            _controllers = arr;
        }
    }
    return _controllers;
}



// setup child controllers
- (void)setupChlidController:(UIViewController * __nonnull)vc title:(NSString * __nullable)title image:(NSString * __nonnull)image selectedImage:(NSString * __nullable)selectedImage {
    if (vc) {
        if (title) {
            vc.title = NSLocalizedString(title, nil);
        } else {
            vc.title = NSStringFromClass(vc.class);
        }
        if (image.length) {
            vc.tabBarItem.image = UIImageFromString(image);
        }
        if (selectedImage) {
            vc.tabBarItem.selectedImage = UIImageFromString(selectedImage);
        }
    }
}

- (NSString *)pathForChildControllersConfiguration{
    NSString *path;
    path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        path = [[NSBundle mainBundle] bundlePath];
        path = [path stringByAppendingPathComponent:@"Frameworks/AXTabKit.framework"];
        
        path = [path stringByAppendingPathComponent:@"AXTabBarController.json"];
    }
    
    return path;
}


#pragma mark - delegate

- (NSString *)classNameForBaseNavigationController{
    return NSStringFromClass(UINavigationController.class);
}

- (NSString *)configurationFilePath{
    NSString *path;
    path = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        path = [[NSBundle mainBundle] bundlePath];
        path = [path stringByAppendingPathComponent:@"Frameworks/AXTabKit.framework"];
        path = [path stringByAppendingPathComponent:@"AXTabBarController.json"];
    }
    return path;
}

- (NSString *)configurationKeyForViewControllerName{
    return @"vc";
}

- (NSString *)configurationKeyForViewControllerTitle{
    return @"title";
}

- (NSString *)configurationKeyForTabBarIconName{
    return @"icon";
}

- (NSString *)configurationKeyForTabBarSelectedIconName{
    return @"icon_sel";
}

@end



