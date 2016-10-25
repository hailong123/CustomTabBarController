//
//  HLTabBarItem.m
//  TabbarControllerDemo
//
//  Created by 123456 on 2016/10/20.
//  Copyright © 2016年 KuXing. All rights reserved.
//

#import "HLTabBarItem.h"

#import "HLBadgeLabel.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface HLTabBarItem () {
    
    UIImage *_selectedImge;
    UIImage *_unselectedImage;
    UIImage *_selectedBackgroundImage;
    UIImage *_unselectedBackgroundImage;
    
    HLBadgeLabel *_badgeLabel;//数值显示的label
    
}

@end

@implementation HLTabBarItem

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self defaultConfig];
        
    }
    
    return self;
    
}

#pragma mark - 基础的配置
- (void)defaultConfig {
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.title = nil;
    self.titlePositionAdjustment = UIOffsetZero;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        _unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],
                                        NSForegroundColorAttributeName:RGBCOLOR(0x99, 0x99, 0x99)
                                        };
    } else {
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
      
        _unselectedTitleAttributes = @{
                                        UITextAttributeFont:[UIFont systemFontOfSize:10],
                                        UITextAttributeTextColor:RGBCOLOR(0x99, 0x99, 0x99)
                                        };
        
#endif
        
    }
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
    {
        _selectedTitleAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:10],
                                     NSForegroundColorAttributeName: RGBCOLOR(0xef, 0x55, 0x5e),
                                     };
    }
    else
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        _selectedTitleAttributes = @{
                                     UITextAttributeFont: [UIFont systemFontOfSize:10],
                                     UITextAttributeTextColor: RGBCOLOR(0xef, 0x55, 0x5e),
                                     };
#endif
    }

    //标记
    _badgeLabel = [[HLBadgeLabel alloc] initWithFrame:CGRectZero];
    _badgeLabel.maxValue = 100;
    [self addSubview:_badgeLabel];

}

#pragma mark - 绘制
- (void)drawRect:(CGRect)rect {
    
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    
    NSDictionary *titleAttributes = nil;
    
    UIImage *backgroundImage     = nil;
    UIImage *image               = nil;
    
    CGFloat imageStartingY       = 0.0f;
    
    if ([self isSelected]) {
        
        image            = _selectedImge;
        backgroundImage  = _selectedBackgroundImage;
        titleAttributes  = [self selectedTitleAttributes];
    
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
    } else {
        
        image           = _unselectedImage;
        backgroundImage = _unselectedBackgroundImage;
        titleAttributes = [self unselectedTitleAttributes];
        
    }
    
    imageSize = [image size];
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroundImage drawInRect:self.bounds];
    
    if (![_title length]) {
        [image drawInRect:CGRectMake(roundf(frameSize.width/2 - imageSize.width /2) + _imagePositionAdjustment.horizontal,
                                     roundf(frameSize.height/2 - imageSize.height / 2) + _imagePositionAdjustment.vertical,
                                     imageSize.width, imageSize.height)];
    } else {
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            
            titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:titleAttributes
                                             context:nil].size;
            
            
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width/2 - imageSize.width/2) +
                                         _imagePositionAdjustment.horizontal,imageStartingY +
                                         _imagePositionAdjustment.vertical ,
                                         imageSize.width, imageSize.height)];
            
            CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
            
            [_title drawInRect:CGRectMake((frameSize.width/2 - titleSize.width / 2) +
                                          _titlePositionAdjustment.horizontal,
                                          imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                          titleSize.width,
                                          titleSize.height)
                withAttributes:titleAttributes];
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            titleSize = [_title sizeWithFont:titleAttributes[UITextAttributeFont]
                           constrainedToSize:CGSizeMake(frameSize.width, 20)];
            UIOffset titleShadowOffset = [titleAttributes[UITextAttributeTextShadowOffset] UIOffsetValue];
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) +
                                         _imagePositionAdjustment.horizontal,
                                         imageStartingY + _imagePositionAdjustment.vertical,
                                         imageSize.width, imageSize.height)];
            
            CGContextSetFillColorWithColor(context, [titleAttributes[UITextAttributeTextColor] CGColor]);
            
            UIColor *shadowColor = titleAttributes[UITextAttributeTextShadowColor];
            
            if (shadowColor) {
                CGContextSetShadowWithColor(context, CGSizeMake(titleShadowOffset.horizontal, titleShadowOffset.vertical),
                                            1.0, [shadowColor CGColor]);
            }
            
            [_title drawInRect:CGRectMake((frameSize.width / 2 - titleSize.width / 2) +
                                          _titlePositionAdjustment.horizontal,
                                          imageStartingY + imageSize.height + _titlePositionAdjustment.vertical,
                                          titleSize.width, titleSize.height)
                      withFont:titleAttributes[UITextAttributeFont]
                 lineBreakMode:NSLineBreakByTruncatingTail];
#endif
        }
        
    }
    //红点
    _badgeLabel.value  = _badgeValue;
    
    [_badgeLabel sizeToFit];
    
    _badgeLabel.frame  = CGRectMake(0, 0, _badgeLabel.bounds.size.width, _badgeLabel.bounds.size.height);
    _badgeLabel.center = CGPointMake(self.bounds.size.width*0.5 + 10, self.bounds.size.height *0.5 - 15);
    _badgeLabel.hidden = NO;
    CGContextRestoreGState(context);
}

#pragma mark - 布局
- (UIImage *)finishedSelectedImage {
    
    return _selectedImge;
    
}

- (UIImage *)finishedUnselectedImage {

    return _unselectedImage;
    
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage
         finishedUnselectedImage:(UIImage *)unselectedImage {
    
    if (selectedImage && (selectedImage != _selectedImge)) {
        
        _selectedImge = selectedImage;
        
    }
    
    if (unselectedImage && (unselectedImage != _unselectedImage)) {
        
        _unselectedImage = unselectedImage;
        
    }
    
}

- (void)setBadgeValue:(NSUInteger)badgeValue {
    
    _badgeValue = badgeValue;
    
    [self setNeedsDisplay];
    
}

- (UIImage *)backgroundSelectedImage {
    
    return _selectedBackgroundImage;
    
}

- (UIImage *)backgroundUnselectedImage {
    
    return _unselectedBackgroundImage;
    
}

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage
                   unselectedImage:(UIImage *)unselectedImage {
    
    if (selectedImage && (selectedImage != _selectedBackgroundImage)) {
        
        _selectedBackgroundImage = selectedImage;
        
    }
    
    if (unselectedImage && (unselectedImage != _unselectedBackgroundImage)) {
        
        _unselectedBackgroundImage = unselectedImage;
        
    }
    
}

@end
