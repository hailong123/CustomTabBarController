# GitRepository
一个基于UIViewController的自定义tabbar 
>###支持自定义背景图
>###支持自定义图标
>###支持 显示消息数量及红点显示

>###使用
    HLViewControllerOne *one     = [[HLViewControllerOne alloc] init];
    HLViewControllerTwo *two     = [HLViewControllerTwo   new];
    HLViewControllerThree *three = [HLViewControllerThree new];
    HLViewControllerFour *four   = [HLViewControllerFour  new];
    
    HLTabBarController *tabBar   = [HLTabBarController new];
    [tabBar setViewControllers:@[one,two,three,four]];
    tabBar.title                 = @"附近";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tabBar];
    self.window.rootViewController = nav;
    
>###遵守代理  
    tabBar.delegate = self; 
>###获取事件

>###- (BOOL)tabBarController:(HLTabBarController *)tabBarController shouldSelectedViewController:(UIViewController *)viewController;

>###- (void)tabBarController:(HLTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
