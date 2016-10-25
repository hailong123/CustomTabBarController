//
//  HLTabBar.m
//  TabbarControllerDemo
//
//  Created by 123456 on 2016/10/20.
//  Copyright © 2016年 KuXing. All rights reserved.
//

#import "HLTabBar.h"
#import "HLTabBarItem.h"

#define HL_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define kLineViewHeight 0.5f//tabbar最上面的线条

@interface HLTabBar ()

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation HLTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonInitialization];
        
    }
    
    return self;
    
}

#pragma mark - 初始化配置
- (void)commonInitialization {
    
    _backgroundView = [[UIView alloc] init];
    
    [self addSubview:_backgroundView];
    
    UIView *splitLineView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HL_WIDTH, kLineViewHeight)];
    splitLineView.backgroundColor = RGBCOLOR(0xcc, 0xcc, 0xcc);
    [_backgroundView addSubview:splitLineView];
    
    //不透明
    [self setTranslucent:NO];
    
}

- (void)layoutSubviews {
    
    CGSize frameSize = self.frame.size;
    
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight,
                                               frameSize.width,
                                               frameSize.height)];
    
    [self setItemWidth:roundf((frameSize.width - [self contectEdgeInsets].left - [self contectEdgeInsets].right)/ [[self items] count])];
    
    NSInteger index = 0;
    
    for (HLTabBarItem *item in [self items]) {
        
        CGFloat itemHeight = [item itemHeight];
        
        if (!itemHeight) {
            
            itemHeight = frameSize.height;
            
        }
        
        [item setFrame:CGRectMake(self.contectEdgeInsets.left + (index * self.itemWidth),
                                  roundf(frameSize.height - itemHeight) - self.contectEdgeInsets.top,
                                  self.itemWidth, itemHeight - self.contectEdgeInsets.bottom)];
        
        [item setNeedsDisplay];
        
        index++;
        
    }
}

#pragma mark - 布局
- (void)setItemWidth:(CGFloat)itemWidth {
    
    if (itemWidth > 0) {
        
        _itemWidth = itemWidth;
        
    }
    
}

- (void)setItems:(NSArray *)items {
    
    for (HLTabBarItem *item in _items) {
        
        [item removeFromSuperview];
        
    }
    
    _items = [items copy];
    
    for (HLTabBarItem *item in _items) {
        
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
        
    }
}

- (void)setHeight:(CGFloat)height {
    
    [self setFrame:CGRectMake(CGRectGetMidX(self.frame),
                              CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
    
}

- (CGFloat)minimumContentHeight {
    
    CGFloat minimumTabBarContentHeight = CGRectGetHeight(self.frame);
    
    for (HLTabBarItem *item in [self items]) {
        
        CGFloat itemHeight = [item itemHeight];
        
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            
            minimumTabBarContentHeight = itemHeight;
            
        }
        
    }
    
    return minimumTabBarContentHeight;
}

#pragma mark - item的选择
- (void)tabBarItemWasSelected:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        
        NSInteger index = [self.items indexOfObject:sender];
        
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            
            return;
            
        }
    }
    
    [self setSelectedItem:sender];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [self.delegate tabBar:self didSelectItemAtIndex:index];
        
    }
}

- (void)setSelectedItem:(HLTabBarItem *)selectedItem {
    
    if (selectedItem == _selectedItem) {
        return;
    }
    
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    
    [_selectedItem setSelected:YES];
    
}

#pragma mark - 设置透明度
- (void)setTranslucent:(BOOL)translucent {
    
    _translucent = translucent;
    
    CGFloat alhpa = (translucent ? 0.5 : 1.0);
    
    [_backgroundView setBackgroundColor:[UIColor colorWithRed:255.0/255.0
                                                        green:255.0/255.0
                                                         blue:255.0/255.0
                                                        alpha:alhpa]];
    
}

@end
