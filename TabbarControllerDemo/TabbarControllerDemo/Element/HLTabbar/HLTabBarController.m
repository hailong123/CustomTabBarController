//
//  HLTabBarController.m
//  iAround
//
//  Created by 123456 on 2016/10/20.
//
//

#import "HLTabBarController.h"

#import "HLTabBarItem.h"

#import <objc/runtime.h>

@interface UIViewController (HLTabBarControllerItemInternal)

- (void)hl_setTabbarController:(HLTabBarController *)tabBarController;

@end

@interface HLTabBarController () {
    
    HLTabBar *_tabBar;
    UIView   *_contentView;
    
}

@end

@implementation HLTabBarController

#pragma mark - view lifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
    
    //设置图标
    NSArray *tabBarItemImages = @[@"tabbar_nearby", @"tabbar_dynamic", @"tabbar_message", @"tabbar_find"];
    
    NSInteger index = 0;
    
    for (HLTabBarItem *item in [_tabBar items]) {
        
        UIImage *selectedImage   = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",[tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[tabBarItemImages objectAtIndex:index]]];
        
        [item setFinishedSelectedImage:selectedImage finishedUnselectedImage:unselectedImage];
        
        NSString *title = nil;
        
        switch (index) {
            case 0:
            {
                title = @"附近";
            }
                break;
                
            case 1:
            {
                title = @"动态";
            }
                break;
            case 2:
            {
                title = @"消息";
            }
                
                break;
            case 3:
                
            {
                title = @"发现";
            }
                
                break;
        }
        
        index++;
        
        item.title = title;
        
    }
    
    //刷新角标
    [self refreshBadgeValue];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:self.selectedIndex];
    
    [self setTabBarHidden:self.isTabBarHidden animation:NO];
    
}

#pragma mark - private Method

- (UIViewController *)selectedViewController {
    
    return [[self viewControllers] objectAtIndex:self.selectedIndex];
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        
        [self.selectedViewController willMoveToParentViewController:nil];
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
        
    }
    
    _selectedIndex = selectedIndex;
    
    [self.tabBar setSelectedItem:self.tabBar.items[selectedIndex]];
    
    [self setSelectedViewController:[self.viewControllers objectAtIndex:selectedIndex]];
    [self addChildViewController:self.selectedViewController];

    [[self contentView] addSubview:self.selectedViewController.view];
    [self.selectedViewController didMoveToParentViewController:self];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    if (_viewControllers && _viewControllers.count) {
        
        for (UIViewController *viewController in _viewControllers) {
            
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
            
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [NSMutableArray array];
        
        for (UIViewController *viewController in viewControllers) {
            
            HLTabBarItem *tabBarItem = [[HLTabBarItem alloc] init];
            
            [tabBarItem setTitle:viewController.title];
            
            [tabBarItems addObject:tabBarItem];
            
            [viewController hl_setTabbarController:self];
            
        }
        
        [self.tabBar setItems:tabBarItems];
        
    } else {
        
        for (UIViewController *viewController in _viewControllers) {
            
            [viewController hl_setTabbarController:nil];
            
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    
    UIViewController *searchedController = viewController;
    
    if ([searchedController navigationController]) {
        
        searchedController = [searchedController navigationController];
        
    }
    
    return [[self viewControllers] indexOfObject:searchedController];
    
}

- (UIView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] init];
        
        [_contentView setBackgroundColor:[UIColor blackColor]];

        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)
         ];
        
    }
    
    return _contentView;
}

- (HLTabBar *)tabBar {
    
    if (!_tabBar) {
        
        _tabBar = [[HLTabBar alloc] init];
        
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleHeight|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin|
                                      UIViewAutoresizingFlexibleTopMargin)
         ];
        
        [_tabBar setDelegate:self];
        
        [_tabBar setTranslucent:YES];
    }
    
    return _tabBar;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden animation:(BOOL)animated {
    
    _tabBarHidden = tabBarHidden;
    
    __weak HLTabBarController *weakSelf = self;
    
    void (^block)() = ^{
    
        CGSize viewSize           = weakSelf.view.bounds.size;
        CGFloat tabBarStratingY   = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight      = CGRectGetHeight(weakSelf.tabBar.frame);
        
        if (!tabBarHeight) {
            
            tabBarHeight = 49;
            
        }
        
        if (!tabBarHidden) {
            
            tabBarStratingY = viewSize.height - tabBarHeight;
            
            if (![weakSelf.tabBar isTranslucent]) {
                
                contentViewHeight -= ([weakSelf.tabBar minimumContentHeight] ?:tabBarHeight);
                
            }
            
            [weakSelf.tabBar setHidden:NO];
        }
        
        [weakSelf.tabBar setFrame:CGRectMake(0, tabBarStratingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight - tabBarHeight)];
        self.selectedViewController.view.frame = [self  contentView].frame;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished) {
    
        if (tabBarHidden) {
            
            [weakSelf.tabBar setHidden:YES];
            
        }
        
    };
    
    if (animated) {
        
        [UIView animateWithDuration:0.24 animations:block completion:completion];
        
    } else {
        
        block();
        completion(YES);
        
    }
}

- (void)setTabBarHidden:(BOOL)tabBarHidden {
    
    [self setTabBarHidden:tabBarHidden animation:NO];
    
}

#pragma mark - HLTabBarDelegate
- (BOOL)tabBar:(HLTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        
        if (![self.delegate tabBarController:self shouldSelectedViewController:self.viewControllers[index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == self.viewControllers[index]) {
        
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
            
        }
        
        return NO;
    }
    
    
    return YES;
}

- (void)tabBar:(HLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    
    if (index < 0 || index > [[self viewControllers] count]) {
        
        return;
        
    }
    
    [self setSelectedIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        
        [self.delegate tabBarController:self didSelectViewController:self.viewControllers[index]];
        
    }
}

#pragma mark - private method
//MARK:这里通过改变badgeValue的数值来决定自定义tabbar上数值显示的类型 -1 显示NEW -2 显示红点
- (void)refreshBadgeValue {
    
    NSInteger messageCount = 0;
    
    HLTabBarItem *item = nil;
    
    for (item in _tabBar.items) {
        
        item.badgeValue = -2;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#pragma mark - UIViewController + HLTabBarControllerItem
@implementation UIViewController (HLTabBarControllerItemInternal)

- (void)hl_setTabbarController:(HLTabBarController *)tabBarController {
    
    objc_setAssociatedObject(self, @selector(hl_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
    
}

@end

@implementation UIViewController (HLTabBarControllerItem)

- (HLTabBarController *)hl_tabBarController {
    
    HLTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(hl_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        
        tabBarController = [self.parentViewController hl_tabBarController];
        
    }
    
    return tabBarController;
}

- (HLTabBarItem *)hl_tabBarItem {
    
    HLTabBarController *tabBarController = [self hl_tabBarController];
    
    NSInteger index = [tabBarController indexForViewController:self];
    
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)hl_setTabBarItem:(HLTabBarItem *)hl_tabBarItem {
    
    HLTabBarController *tabBarController = [self hl_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    HLTabBar *tabBar = [tabBarController tabBar];
    NSInteger index  = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:hl_tabBarItem];
    [tabBar setItems:tabBarItems];
    
}

@end
