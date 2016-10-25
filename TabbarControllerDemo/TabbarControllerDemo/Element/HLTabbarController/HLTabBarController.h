//
//  HLTabBarController.h
//  TabbarControllerDemo
//  Created by 123456 on 2016/10/20.
//
//

#import <UIKit/UIKit.h>

#import "HLTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@class HLTabBarController;

@protocol HLTabbarControllerDelegate <NSObject>

@optional

- (BOOL)tabBarController:(HLTabBarController *)tabBarController shouldSelectedViewController:(UIViewController *)viewController;

- (void)tabBarController:(HLTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end


@interface HLTabBarController : UIViewController<HLTabBarDelegate>

@property (nonatomic, assign) id <HLTabbarControllerDelegate> delegate;

@property (nonatomic, strong, readonly) HLTabBar *tabBar;

//该控制器管理所有的viewController
@property (nonatomic, strong) NSArray *viewControllers;

//被选中的控制器
@property (nonatomic, weak) UIViewController *selectedViewController;

//被选中的ViewController的index
@property (nonatomic, assign) NSInteger selectedIndex;

//是否隐藏tabBar
@property (nonatomic, assign, getter=isTabBarHidden) BOOL tabBarHidden;


- (void)setTabBarHidden:(BOOL)tabBarHidden animation:(BOOL)animated;

@end


@interface UIViewController (HLTabBarControllerItem)

//获取某个ViewController所属的tabBarController
@property (nonatomic, strong ,readonly) HLTabBarController * hl_tabBarController;

//获取某个归属tabBarController的viewController的tabBarItem
@property (nonatomic, assign, setter=hl_setTabBarItem:) HLTabBarItem *hl_tabBarItem;

@end

NS_ASSUME_NONNULL_END
