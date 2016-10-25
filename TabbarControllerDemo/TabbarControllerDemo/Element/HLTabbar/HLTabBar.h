//
//  HLTabBar.h
//  TabbarControllerDemo
//
//  Created by 123456 on 2016/10/20.
//  Copyright © 2016年 KuXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HLTabBar,HLTabBarItem;

@protocol HLTabBarDelegate <NSObject>

//选中的索引
- (void)tabBar:(HLTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;
//将要选中的索引
- (BOOL)tabBar:(HLTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

@end

@interface HLTabBar : UIView

@property (nonatomic, assign) id <HLTabBarDelegate> delegate;

//TabBarItem数组
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) HLTabBarItem *selectedItem;

//背景的父视图 如果有额外的背景 请加为backgroundView 的subView
@property (nonatomic, readonly) UIView *backgroundView;

@property (nonatomic, assign) UIEdgeInsets contectEdgeInsets;

//是否半透明
@property (nonatomic, assign, getter=isTranslucent) BOOL translucent;

- (void)setHeight:(CGFloat)height;

- (CGFloat)minimumContentHeight;

@end

NS_ASSUME_NONNULL_END
