//
//  ZHTabBarController.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/23.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "TLTabBarController.h"

#import "TLNavigationController.h"
#import "TLUserLoginVC.h"
#import "LangSwitcher.h"
#import "UIColor+theme.h"
#import "AppConfig.h"

@interface TLTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation TLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

    NSArray *titles = @[
                        [LangSwitcher switchLang:@"首页" key:nil],
                        [LangSwitcher switchLang:@"钱包" key:nil],
                        [LangSwitcher switchLang:@"我的" key:nil]
                        ];
    NSArray *VCNames = @[@"HomeVC", @"TLWalletVC", @"TLMineVC"];
    
    NSArray *imageNames = @[@"home", @"钱包00", @"我的00"];
    NSArray *selectedImageNames = @[@"home_select", @"钱包01", @"我的01"];
    
    
    for (int i = 0; i < imageNames.count; i++) {
        
        if (i == 0 && [AppConfig config].isUploadCheck) {
            
            continue;
        }
        
        [self addChildVCWithTitle:titles[i]
                       controller:VCNames[i]
                      normalImage:imageNames[i]
                    selectedImage:selectedImageNames[i]];
    }
    
    self.selectedIndex =[AppConfig config].isUploadCheck ? 0 : 0;
    
    //
    UIView *tabBarBgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    tabBarBgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:tabBarBgView atIndex:0];
//  self.tabBar.backgroundColor = [UIColor whiteColor];
    
}


- (UIImage *)changImageColorWithImage:(UIImage *)image  color:(UIColor *)targetColor blendModel:(CGBlendMode)mode
{
    //获取画布
    UIGraphicsBeginImageContext(image.size);
    //画笔沾取颜色
    [targetColor setFill];
    
    CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(drawRect);
    [image drawInRect:drawRect blendMode:mode alpha:1];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)addChildVCWithTitle:(NSString *)title
                 controller:(NSString *)controllerName
                normalImage:(NSString *)normalImageName
              selectedImage:(NSString *)selectedImageName
{
    Class vcClass = NSClassFromString(controllerName);
    UIViewController *vc = [[vcClass alloc] init];
//    vc.title = title;
    
    //获得原始图片
    UIImage *normalImage = [self getOrgImage:[UIImage imageNamed:normalImageName]];
    UIImage *selectedImage = [self getOrgImage:[UIImage imageNamed:selectedImageName]];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:normalImage
                                                     selectedImage:selectedImage];
//    tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 100);
    
    //title颜色
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor themeColor]
                                         } forState:UIControlStateSelected];
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : [UIColor textColor]
                                         } forState:UIControlStateNormal];
    vc.tabBarItem = tabBarItem;
    TLNavigationController *navigationController = [[TLNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:navigationController];
    
}

- (UIImage *)getOrgImage:(UIImage *)image {
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

#pragma mark 判断是否登录若没登录跳转到登录页面
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    
    //赋值更改前的index
    self.currentIndex = tabBarController.selectedIndex;
    return YES;
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    CoinWeakSelf;
    
    NSInteger idx = tabBarController.selectedIndex;
    
    if ([AppConfig config].isUploadCheck) {
        
        //判断点击的Controller是不是需要登录，如果是，那就登录
        if((idx == 1 || idx == 2) && ![TLUser user].isLogin) {
            
            TLUserLoginVC *loginVC = [TLUserLoginVC new];
            
            loginVC.loginSuccess = ^{
                
                weakSelf.selectedIndex = idx;
                
            };
            
            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
            self.selectedIndex = _currentIndex;
            
        }
        
    } else {
        
        //判断点击的Controller是不是需要登录，如果是，那就登录
        if((idx == 1 || idx == 2) && ![TLUser user].isLogin) {
            
            TLUserLoginVC *loginVC = [TLUserLoginVC new];
            
            loginVC.loginSuccess = ^{
                
                weakSelf.selectedIndex = idx;
                
            };
            
            TLNavigationController *nav = [[TLNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
            self.selectedIndex = _currentIndex;
            
        }
        
    }
 
    
}

@end
