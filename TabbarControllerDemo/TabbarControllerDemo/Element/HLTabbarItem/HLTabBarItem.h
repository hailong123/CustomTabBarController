//
//  HLTabBarItem.h
//  TabbarControllerDemo
//
//  Created by 123456 on 2016/10/20.
//  Copyright © 2016年 KuXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLBadgeLabel;

NS_ASSUME_NONNULL_BEGIN

@interface HLTabBarItem : UIControl

@property (nonatomic, assign)CGFloat itemHeight;

#pragma mark - TabBar标题

@property (nonatomic, copy,nullable) NSString *title;

@property (nonatomic, assign) UIOffset titlePositionAdjustment;

//字体的属性
@property (nonatomic, strong) NSDictionary *selectedTitleAttributes;
@property (nonatomic, strong) NSDictionary *unselectedTitleAttributes;

#pragma mark - TabBar图片
@property (nonatomic, assign) UIOffset imagePositionAdjustment;

//选中的图片
- (UIImage *)finishedSelectedImage;
//未选中的图片
- (UIImage *)finishedUnselectedImage;

- (void)setFinishedSelectedImage:(UIImage *)selectedImage finishedUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - TabBar背景
//选中的背景图
- (UIImage *)backgroundSelectedImage;
//未选中的背景图
- (UIImage *)backgroundUnselectedImage;

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage unselectedImage:(UIImage *)unselectedImage;

#pragma mark - TabBar红点
@property (nonatomic, assign) NSUInteger badgeValue;

@end

NS_ASSUME_NONNULL_END
