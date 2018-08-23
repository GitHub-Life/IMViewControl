//
//  IMStarView.m
//  Test
//
//  Created by 万涛 on 2018/6/13.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMStarView.h"

@implementation IMStarView

float Radian(float angle) {
    return angle / 180 * M_PI;
}

- (UIColor *)starBorderColor {
    if (!_starBorderColor) {
        _starBorderColor = [UIColor colorWithRed:0 green:122.0f/255 blue:1 alpha:1];
    }
    return _starBorderColor;
}

- (CGFloat)starBorderWidth {
    if (_starBorderWidth <= 0) {
        _starBorderWidth = 0.5;
    }
    return _starBorderWidth * 2;
}

- (UIColor *)starFillColor {
    if (!_starFillColor) {
        _starFillColor = [UIColor colorWithRed:0 green:122.0f/255 blue:1 alpha:1];
    }
    return _starFillColor;
}

- (void)setProgress:(CGFloat)progress {
    if (_progress == progress) return;
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;
    _progress = progress;
    [self setNeedsDisplay];
}

/*
          1
       5 ⭐️ 2
        4  3
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat width = CGRectGetWidth(rect) - _starEdgeInsets.left - _starEdgeInsets.right;
    CGFloat height = CGRectGetHeight(rect) - _starEdgeInsets.top - _starEdgeInsets.bottom;
    CGPoint center = CGPointMake(_starEdgeInsets.left + width / 2, _starEdgeInsets.top + height / 2);
    
    CGFloat bigRadius = [self getStarbigRadiusWithRect:CGRectMake(_starEdgeInsets.left, _starEdgeInsets.top, width, height)];
    CGPoint starCenter = CGPointMake(center.x, center.y + (bigRadius - bigRadius * (cos(Radian(36)) + 1) / 2));

    CGPoint bigPoint1 = CGPointMake(starCenter.x, starCenter.y - bigRadius);
    CGPoint bigPoint2 = CGPointMake(starCenter.x + bigRadius * cos(Radian(18)), starCenter.y - bigRadius * sin(Radian(18)));
    CGPoint bigPoint3 = CGPointMake(starCenter.x + bigRadius * sin(Radian(36)), starCenter.y + bigRadius * cos(Radian(36)));
    CGPoint bigPoint4 = CGPointMake(starCenter.x - bigRadius * sin(Radian(36)), starCenter.y + bigRadius * cos(Radian(36)));
    CGPoint bigPoint5 = CGPointMake(starCenter.x - bigRadius * cos(Radian(18)), starCenter.y - bigRadius * sin(Radian(18)));
    
    CGFloat smallRadius = [self getStarSmallRadiusWithBigRadius:bigRadius];
    CGPoint smallPoint1 = CGPointMake(starCenter.x + smallRadius * cos(Radian(54)), starCenter.y - smallRadius * sin(Radian(54)));
    CGPoint smallPoint2 = CGPointMake(starCenter.x + smallRadius * cos(Radian(18)), starCenter.y + smallRadius * sin(Radian(18)));
    CGPoint smallPoint3 = CGPointMake(starCenter.x, starCenter.y + smallRadius);
    CGPoint smallPoint4 = CGPointMake(starCenter.x - smallRadius * cos(Radian(18)), starCenter.y + smallRadius * sin(Radian(18)));
    CGPoint smallPoint5 = CGPointMake(starCenter.x - smallRadius * cos(Radian(54)), starCenter.y - smallRadius * sin(Radian(54)));
    
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    CGFloat progressWidth = _progress * (bigPoint2.x - bigPoint5.x);
    [progressPath moveToPoint:CGPointMake(bigPoint5.x, bigPoint1.y)];
    [progressPath addLineToPoint:CGPointMake(bigPoint5.x + progressWidth, bigPoint1.y)];
    [progressPath addLineToPoint:CGPointMake(bigPoint5.x + progressWidth, bigPoint4.y)];
    [progressPath addLineToPoint:CGPointMake(bigPoint5.x, bigPoint4.y)];
    [progressPath closePath];
    [self.starFillColor setFill];
    [progressPath fill];
    
    UIBezierPath *starPath = [UIBezierPath bezierPath];
    [starPath moveToPoint:bigPoint1];
    [starPath addLineToPoint:smallPoint1];
    [starPath addLineToPoint:bigPoint2];
    [starPath addLineToPoint:smallPoint2];
    [starPath addLineToPoint:bigPoint3];
    [starPath addLineToPoint:smallPoint3];
    [starPath addLineToPoint:bigPoint4];
    [starPath addLineToPoint:smallPoint4];
    [starPath addLineToPoint:bigPoint5];
    [starPath addLineToPoint:smallPoint5];
    [starPath closePath];
    [self.starBorderColor setStroke];
    [starPath setLineJoinStyle:kCGLineJoinRound];
    [starPath setLineWidth:self.starBorderWidth];
    [starPath stroke];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = starPath.CGPath;
    self.layer.mask = maskLayer;
}

/**
 获取五角星大圆半径
 @param rect 绘制区域
 @return 五角星大圆半径
 */
- (CGFloat)getStarbigRadiusWithRect:(CGRect)rect {
    // 横向 r * cos(18°) * 2 = width
    CGFloat radius_H = CGRectGetWidth(rect) / 2 / cos(Radian(18));
    // 纵向 r * (cos(36°) + 1) = height
    CGFloat radius_V = CGRectGetHeight(rect) / (cos(Radian(36)) + 1);
    return MIN(radius_H, radius_V);
}

/**
 获取五角星小圆半径
 @param bigRadius 五角星大圆半径
 @return 五角星小圆半径
 */
- (CGFloat)getStarSmallRadiusWithBigRadius:(CGFloat)bigRadius {
    return bigRadius * sin(Radian(18)) / cos(Radian(36));
}

@end
