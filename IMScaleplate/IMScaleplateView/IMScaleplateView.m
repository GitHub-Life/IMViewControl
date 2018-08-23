//
//  IMScaleplateView.m
//  IMScaleplateDemo
//
//  Created by 万涛 on 2018/7/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMScaleplateView.h"

@interface IMScaleplateView ()

@property (nonatomic, assign) CGFloat startDrawOffsetX;
@property (nonatomic, assign) CGFloat endDrawOffsetX;

@property (nonatomic, assign) NSInteger startDrawScaleIndex;
@property (nonatomic, assign) NSInteger endDrawScaleIndex;

@property (nonatomic, assign) BOOL showInit;

@end

@implementation IMScaleplateView

- (void)setShowInitVolume:(CGFloat)showInitVolume {
    _showInit = YES;
    _showInitVolume = showInitVolume;
}

- (void)setStartDrawScaleIndex:(NSInteger)startDrawScaleIndex endDrawScaleIndex:(NSInteger)endDrawScaleIndex {
    _startDrawScaleIndex = startDrawScaleIndex;
    _endDrawScaleIndex = endDrawScaleIndex;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_endDrawScaleIndex < _startDrawScaleIndex) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSInteger i = _startDrawScaleIndex; i < _endDrawScaleIndex + 1; i++) {
        [self.scaleColor setStroke];
        CGFloat x = i * self.shortScaleInterval + self.contentInsets.left;
        BOOL isLongScale = [self isLongScaleWithScaleIndex:i];
        CGContextSetLineWidth(context, isLongScale ? self.longScaleWidth : self.shortScaleWidth);
        CGContextMoveToPoint(context, x, self.contentInsets.top);
        CGContextAddLineToPoint(context, x, self.contentInsets.top + (isLongScale ? self.longScaleHeight : self.shortScaleHeight));
        CGContextMoveToPoint(context, x, CGRectGetHeight(rect) - self.contentInsets.bottom);
        CGContextAddLineToPoint(context, x, CGRectGetHeight(rect) - (isLongScale ? self.longScaleHeight : self.shortScaleHeight) - self.contentInsets.bottom);
        CGContextStrokePath(context);
        if (isLongScale) {
            NSString *floatDecimals = [NSString stringWithFormat:@"%%.%df", self.numberDecimals];
            NSString *numStr = [NSString stringWithFormat:floatDecimals, i * self.shortScaleVolume + self.startVolume];
            CGSize numSize = [numStr sizeWithAttributes:@{NSFontAttributeName : self.numberFont}];
            [numStr drawInRect:CGRectMake(x - numSize.width / 2, self.drawCenterY - numSize.height / 2, numSize.width, numSize.height) withAttributes:@{NSFontAttributeName : self.numberFont, NSForegroundColorAttributeName : self.numberColor}];
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake((_endDrawOffsetX / 2 + _startDrawOffsetX / 2) - self.shortScaleHeight, self.contentInsets.top)];
    [path addLineToPoint:CGPointMake((_endDrawOffsetX / 2 + _startDrawOffsetX / 2) + self.shortScaleHeight, self.contentInsets.top)];
    [path addLineToPoint:CGPointMake((_endDrawOffsetX / 2 + _startDrawOffsetX / 2), self.contentInsets.top + self.shortScaleHeight)];
    [path closePath];
    [self.scaleColor setFill];
    [path fill];
    
    if (_showInit && _showInitVolume >= _startDrawScaleIndex * _shortScaleVolume
        && _shortScaleVolume <= _endDrawScaleIndex * _shortScaleVolume) {
        [self.scaleColor setStroke];
        CGContextSetLineWidth(context, self.longScaleWidth);
        CGFloat x = (_showInitVolume - _startVolume) / _shortScaleVolume * _shortScaleInterval + self.contentInsets.left;
        CGContextMoveToPoint(context, x, self.contentInsets.top);
        CGContextAddLineToPoint(context, x, CGRectGetHeight(rect) - self.contentInsets.bottom);
        CGContextStrokePath(context);
    }
    
    if (_gradientMask) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = @[(id)self.backgroundColor.CGColor, (id)[self.backgroundColor colorWithAlphaComponent:0].CGColor, (id)self.backgroundColor.CGColor];
        CGFloat locations[3]={0, 0.5, 1};
        CGGradientRef gradient= CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(_startDrawOffsetX, 0), CGPointMake(_endDrawOffsetX, 0), !kCGGradientDrawsBeforeStartLocation);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }
}

- (BOOL)isLongScaleWithScaleIndex:(NSInteger)scaleIndex {
    return scaleIndex % self.longScaleIntervalCount == 0;
}

- (CGFloat)drawCenterY {
    return (CGRectGetHeight(self.bounds) - self.contentInsets.top - self.contentInsets.bottom) / 2 + self.contentInsets.top;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _startDrawOffsetX = scrollView.contentOffset.x;
    _endDrawOffsetX = scrollView.contentOffset.x + CGRectGetWidth(scrollView.bounds);
    NSInteger startScaleIndex = floor((_startDrawOffsetX - self.contentInsets.left) / self.shortScaleInterval);
    NSInteger endScaleIndex = ceil((_endDrawOffsetX - self.contentInsets.left) / self.shortScaleInterval);
    if (startScaleIndex < 0) {
        startScaleIndex = 0;
    }
    NSInteger maxScaleIndex = (self.endVolume - self.startVolume) / self.shortScaleVolume;
    if (endScaleIndex > maxScaleIndex) {
        endScaleIndex = maxScaleIndex;
    }
    [self setStartDrawScaleIndex:startScaleIndex endDrawScaleIndex:endScaleIndex];
    
    CGFloat currentVolume = ((_endDrawOffsetX / 2 + _startDrawOffsetX / 2) - self.contentInsets.left) / self.shortScaleInterval * self.shortScaleVolume + self.startVolume;
    if (currentVolume < self.startVolume) {
        currentVolume = self.startVolume;
    }
    if (currentVolume > self.endVolume) {
        currentVolume = self.endVolume;
    }
    self.currentVolume = currentVolume;
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaleplateView:currentVolume:)]) {
        [self.delegate scaleplateView:self currentVolume:currentVolume];
    }
 
    if (@available(iOS 10.0, *)) { // 微振动
        if (currentVolume > self.startVolume && currentVolume < self.endVolume) {
            CGFloat m = currentVolume / self.shortScaleVolume;
            if (m == (NSInteger)m) {
                [[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium] impactOccurred];
            }
        }
    }
}


#pragma mark - 属性默认值设置
- (CGFloat)shortScaleWidth {
    if (_shortScaleWidth <= 0) {
        _shortScaleWidth = 1.f;
    }
    return _shortScaleWidth;
}

- (CGFloat)shortScaleHeight {
    if (_shortScaleHeight <= 0) {
        _shortScaleHeight = 5.f;
    }
    return _shortScaleHeight;
}

- (CGFloat)longScaleWidth {
    if (_longScaleWidth <= 0) {
        _longScaleWidth = 1.5f;
    }
    return _longScaleWidth;
}

- (CGFloat)longScaleHeight {
    if (_longScaleHeight <= 0) {
        _longScaleHeight = 10.f;
    }
    return _longScaleHeight;
}

- (CGFloat)shortScaleInterval {
    if (_shortScaleInterval <= 0) {
        _shortScaleInterval = 10.f;
    }
    return _shortScaleInterval;
}

- (NSInteger)longScaleIntervalCount {
    if (_longScaleIntervalCount <= 0) {
        _longScaleIntervalCount = 5;
    }
    return _longScaleIntervalCount;
}

- (UIColor *)scaleColor {
    if (!_scaleColor) {
        _scaleColor = UIColor.blackColor;
    }
    return _scaleColor;
}

- (CGFloat)shortScaleVolume {
    if (_shortScaleVolume <= 0) {
        _shortScaleVolume = 1.f;
    }
    return _shortScaleVolume;
}

- (UIColor *)numberColor {
    if (!_numberColor) {
        _numberColor = self.scaleColor;
    }
    return _numberColor;
}

- (UIFont *)numberFont {
    if (!_numberFont) {
        _numberFont = [UIFont systemFontOfSize:12];
    }
    return _numberFont;
}

@end
