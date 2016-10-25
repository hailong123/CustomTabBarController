//
//  HLBadgeLabel.m
//  TabbarControllerDemo
//
//  Created by 123456 on 2016/10/20.
//  Copyright © 2016年 KuXing. All rights reserved.
//

#import "HLBadgeLabel.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation HLBadgeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //初始化配置
        [self initState];
        
    }
    
    return self;
    
}

#pragma mark - 初始化配置
- (void)initState {
    
    self.opaque = NO;
    self.point  = NO;
    self.shadow = NO;
    self.shine  = NO;
    self.hiddenWhenZero         = YES;
    self.userInteractionEnabled = NO;
    
    self.pad         = 1;
    self.strokeWidth = 0;
    self.maxValue    = 100;
    
    self.font         = [UIFont systemFontOfSize:10];
    self.aligment     = NSTextAlignmentCenter;
    self.fillColor    = RGBCOLOR(0xff, 0x6a, 0x75);
    self.textColor    = [UIColor whiteColor];
    self.strokeColor  = [UIColor whiteColor];
    self.valueString  = nil;
    self.shadowColor  = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.shadowOffset = CGSizeMake(0, 1);
    
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - publicMethod
- (void)sizeToFit {
    
    CGSize size = self.badgeSize;
    
    self.frame  = CGRectMake(0, 0, size.width+0, size.height+0);
    
}

- (void)drawRect:(CGRect)rect {
    
    CGRect viewBounds           = self.bounds;
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGSize numberSize = CGSizeMake(0, 7);
    
    if (!self.point) {
        numberSize = [self.valueString sizeWithAttributes:@{NSFontAttributeName:self.font}];
    }
    
    CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];

    CGRect badgeRect    = CGPathGetBoundingBox(badgePath);
    
    badgeRect.origin.x    = 0;
    badgeRect.origin.y    = 0;
    badgeRect.size.width  = ceil(badgeRect.size.width);
    badgeRect.size.height = ceil(badgeRect.size.height);
    
    CGContextSaveGState(currentContext);
    CGContextSetLineWidth(currentContext, self.strokeWidth);
    CGContextSetFillColorWithColor(currentContext, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(currentContext, self.strokeColor.CGColor);
    
    badgeRect.size.width += ceilf(self.strokeWidth/2.0);
    badgeRect.size.height += ceilf(self.strokeWidth/2.0);
    
    CGPoint ctm;
    
    switch (self.aligment) {
        case NSTextAlignmentJustified:
        case NSTextAlignmentNatural:
        case NSTextAlignmentCenter:
        {
            ctm = CGPointMake(round((viewBounds.size.width - badgeRect.size.width) / 2),
                              round((viewBounds.size.height - badgeRect.size.height) /2));
        }
            break;
        case NSTextAlignmentLeft:
        {
            ctm = CGPointMake(0, round((viewBounds.size.height - badgeRect.size.height)/2));
        }
            break;
        case NSTextAlignmentRight:
        {
            ctm = CGPointMake((viewBounds.size.width - badgeRect.size.width),
                              round((viewBounds.size.height -badgeRect.size.height)/2));
        }
            break;
    }
    
    CGContextTranslateCTM(currentContext, ctm.x, ctm.y);
    
    //添加阴影
    if (self.shadow) {
        
        CGContextSaveGState(currentContext);
        
        CGSize blurSize = self.shadowOffset;
        
        CGContextSetShadowWithColor(currentContext, blurSize, 1 ,self.shadowColor.CGColor);
        CGContextAddPath(currentContext, badgePath);
    
    }
    
    CGContextBeginPath(currentContext);
    CGContextAddPath(currentContext, badgePath);
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    //添加高光
    if (self.shine) {
        
        CGContextBeginPath(currentContext);
        CGContextAddPath(currentContext, badgePath);
        CGContextClosePath(currentContext);
        CGContextClip(currentContext);
        
        CGColorSpaceRef colorSpace      = CGColorSpaceCreateDeviceRGB();
        CGFloat shinyColorGradient[8]   = {1,1,1,0.8,1,1,1,0};
        CGFloat shinyLocationGradent[2] = {0,1};
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                     shinyColorGradient,
                                                                     shinyLocationGradent, 2);
        
        CGContextSaveGState(currentContext);
        CGContextBeginPath(currentContext);
        CGContextMoveToPoint(currentContext, 0, 0);
        
        CGFloat shineStartY = badgeRect.size.height*0.25;
        CGFloat shineStopY  = shineStartY + badgeRect.size.height*0.4;
        
        CGContextAddLineToPoint(currentContext, 0, shineStartY);
        
        CGContextAddCurveToPoint(currentContext, 0,
                                 shineStopY,
                                 badgeRect.size.width,
                                 shineStopY,
                                 badgeRect.size.width,
                                 shineStartY);
        
        CGContextAddLineToPoint(currentContext, badgeRect.size.width, 0);
        CGContextClosePath(currentContext);
        CGContextClip(currentContext);
        
        CGContextDrawLinearGradient(currentContext,
                                    gradient,
                                    CGPointMake(badgeRect.size.width / 2.0, 0),
                                    CGPointMake(badgeRect.size.width /2.0, shineStopY),
                                    kCGGradientDrawsBeforeStartLocation);
        CGContextRestoreGState(currentContext);
        
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        
    }
    
    CGContextRestoreGState(currentContext);
    CGPathRelease(badgePath);
    
    CGContextSaveGState(currentContext);
    CGContextSetFillColorWithColor(currentContext, self.textColor.CGColor);
    
    CGPoint textPoint = CGPointMake(ctm.x + (badgeRect.size.width - numberSize.width)/2, ctm.y + (badgeRect.size.height - numberSize.height) / 2.0);
    
    [self.valueString drawAtPoint:textPoint withAttributes:@{NSFontAttributeName:self.font}];
    
    CGContextRestoreGState(currentContext);
}


//得到路径
- (CGPathRef)newBadgePathForTextSize:(CGSize )inSize {
    
    CGFloat arcRadius  = ceil((inSize.height + self.pad) / 2.0);
    
    CGFloat badgeWidth = 2.0*arcRadius;
    CGFloat badgeWidthAdjustment = inSize.width - inSize.height / 2.0;
    
    if (badgeWidthAdjustment > 0.0) {
        badgeWidth += badgeWidthAdjustment;
    }
    
    CGMutablePathRef badgePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(badgePath, NULL, arcRadius, 0);
    CGPathAddArc(badgePath, NULL, arcRadius, arcRadius, arcRadius, 3.0*M_PI_2, M_PI_2, YES);
    CGPathAddLineToPoint(badgePath, NULL, badgeWidth-arcRadius, 2.0*arcRadius);
    CGPathAddArc(badgePath, NULL, badgeWidth-arcRadius, arcRadius, arcRadius, M_PI_2, 3.0*M_PI_2, YES);
    CGPathAddLineToPoint(badgePath, NULL, arcRadius, 0);
    
    return badgePath;
}

#pragma mark - 成员方法
- (void)setValue:(NSInteger)value {
    
    _value = value;
    
    if (_value == -1) {//显示NEW
        
        _point = NO;
        
        self.valueString = @"NEW";
        
    } else if (_value == -2) {//显示红点
        
        self.point = YES;
        
    } else if (self.hiddenWhenZero && _value == 0) {
    
        self.hidden = YES;
        
    } else if ( _value > 0) {
        _point = NO;
        
        self.hidden = NO;
        
        if (_value > self.maxValue) {
            
            if (_ellipsis) {
                self.valueString = @"...";
            } else {
                self.valueString = [NSString stringWithFormat:@"%ld+",(long)self.maxValue];
            }
            
        } else {
            
            self.valueString = [NSString stringWithFormat:@"%lu",(unsigned long) value];
            
        }
    }
}

- (void)setAddValue:(NSInteger)addValue {
    
    _addValue = addValue;
    
    if (self.hiddenWhenZero && _addValue == 0) {
        
        self.hidden = YES;
        
    } else if (_addValue > 0) {
        
        self.hidden = NO;
        
        if (_addValue > self.maxValue) {
            
            self.valueString = [NSString stringWithFormat:@"+%ld",(long)self.maxValue];
            
        } else {
            
            self.valueString = [NSString stringWithFormat:@"+%lu",(unsigned long)addValue];
            
        }
    }
}

- (void)setValueString:(NSString *)valueString {
    
    _valueString = [valueString copy];
    
    if (self.point) {
        self.hidden = NO;
    } else {
        self.hidden = (_valueString == nil || [_valueString length] <= 0);
    }
    
    [self setNeedsDisplay];
    
}

- (CGSize)badgeSize {
    
    CGSize numberSize = CGSizeMake(0, 10);
    
    if (!self.point) {
        
        numberSize = [self.valueString sizeWithAttributes:@{NSFontAttributeName:self.font}];
        
    }
    
    CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];
    
    CGRect badgeRect    = CGPathGetBoundingBox(badgePath);
    
    badgeRect.origin.x    = 0;
    badgeRect.origin.y    = 0;
    badgeRect.size.width  = ceil(badgeRect.size.width);
    badgeRect.size.height = ceil(badgeRect.size.height);
    
    CGPathRelease(badgePath);
    
    return badgeRect.size;
}

@end
