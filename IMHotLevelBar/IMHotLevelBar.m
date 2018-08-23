//
//  IMHotLevelBar.m
//  Test
//
//  Created by 万涛 on 2018/7/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMHotLevelBar.h"

@interface IMHotLevelBar ()

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) CGFloat drawPercent;

@end

@implementation IMHotLevelBar

- (UIImage *)image {
    if (!_image) {
        _image = [UIImage imageNamed:@"ico_hot_level"];
    }
    return _image;
}

- (void)setValueType_ib:(NSInteger)valueType_ib {
    self.valueType = valueType_ib;
}

- (void)setPercent:(CGFloat)percent {
    if (percent < 0) {
        percent = 0;
    } else if (percent > 1) {
        percent = 1;
    }
    _percent = percent;
    switch (_valueType) {
        case IMHotLevelValueTypeFivePart: {
            CGFloat part = 1.0f / 5;
            _drawPercent = ceil(percent / part) * part;
        } break;
        case IMHotLevelValueTypeTenPart: {
            CGFloat part = 1.0f / 10;
            _drawPercent = ceil(percent / part) * part;
        } break;
        default:
            _drawPercent = percent;
            break;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    CGFloat unit = MIN(width / 5, height);
    CGFloat drawMinX = (width - unit * 5) / 2;
    CGFloat drawMinY = (height - unit) / 2;
    CGFloat drawWidth = unit * 5;
    CGFloat drawHeight = unit;
    
    [self.fireBgTintColor set];
    CGFloat grayWidth = _showFireBg ? drawWidth : ceil(_drawPercent / (1.0f / 5)) * (1.0f / 5) * drawWidth;
    UIRectFill(CGRectMake(drawMinX, drawMinY, grayWidth, drawHeight));
    
    UIBezierPath *gradientPath = [UIBezierPath bezierPathWithRect:CGRectMake(drawMinX, drawMinY, drawWidth * _drawPercent, drawHeight)];
    NSArray *colors = @[(id)UIColor.redColor.CGColor, (id)UIColor.yellowColor.CGColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(drawMinX, drawMinY);
    CGPoint endPoint = CGPointMake(drawMinX, drawMinY + drawHeight);
    CGContextSaveGState(context);
    CGContextAddPath(context, gradientPath.CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    [self.backgroundColor set];
    [self.image drawInRect:CGRectMake(drawMinX, drawMinY, drawWidth, drawHeight)];
}

- (UIColor *)fireBgTintColor {
    return _fireBgTintColor ?: UIColor.groupTableViewBackgroundColor;
}

@end
