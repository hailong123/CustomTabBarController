//
//  HLBadgeLabel.h
//  TabbarControllerDemo
//
//  Created by 123456 on 2016/10/20.
//  Copyright © 2016年 KuXing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//显示数字 ,new, 或者 远点的提示标签
@interface HLBadgeLabel : UIView
//间隙
@property (nonatomic, assign) NSUInteger pad;
//最大的数值
@property (nonatomic, assign) NSInteger maxValue;//默认100
//这个数值是显示在群组的标记使用,跟新此数值将会跟新视图显示
@property (nonatomic, assign) NSInteger addValue;
//当前显示类型的数值, 跟新此数值就会更新视图的显示类型
@property (nonatomic, assign) NSInteger value;//当value 为-1 时显示NEW, 当value为-2 时显示圆点
//标记边缘线的宽度
@property (nonatomic, assign) NSInteger strokeWidth;

//字体
@property (nonatomic, strong) UIFont *font;

//阴影的颜色
@property (nonatomic, assign) UIColor *shadowColor;

//填充颜色
@property (nonatomic, strong) UIColor *fillColor;
//标记边缘线的颜色
@property (nonatomic, strong) UIColor *strokeColor;

//标记字体的颜色
@property (nonatomic, strong) UIColor *textColor;
//字体的对齐方式
@property (nonatomic, assign) NSTextAlignment aligment;
//标记视图的大小
@property (nonatomic, assign, readonly) CGSize badgeSize;

//阴影的偏移量
@property (nonatomic, assign) CGSize shadowOffset;

//显示的字符
@property (nonatomic, copy,nullable) NSString *valueString;

//是否加亮
@property (nonatomic, assign, getter=isShine) BOOL shine;

//是否是圆点提示
@property (nonatomic, assign, getter=isPoint) BOOL point;

//是否有阴影
@property (nonatomic, assign, getter=isShadow) BOOL shadow;

//当数值为0时是否隐藏
@property (nonatomic, assign, getter=isHiddenWhenZero) BOOL hiddenWhenZero;

//省略号提示
@property (nonatomic, assign, getter=isEllipsis)BOOL ellipsis;//如果超过了最大的数值,要显示... 而不是MaxValue+ 则置为YES

@end

NS_ASSUME_NONNULL_END
