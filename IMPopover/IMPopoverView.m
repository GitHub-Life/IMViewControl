//
//  IMPopoverView.m
//  IMPopover
//
//  Created by 万涛 on 2018/6/7.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMPopoverView.h"

@interface IMPopoverView ()

/** 水平边距(即属性值中 left、right有效，top、bottom无效) */
@property (nonatomic, assign) UIEdgeInsets margin_H;

@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, assign) CGFloat windowW;
@property (nonatomic, assign) CGFloat windowH;

@end

@implementation IMPopoverView

float Radian(float angle) {
    return angle / 180 * M_PI;
}

- (instancetype)init {
    if (self = [super init]) {
        _margin_H = UIEdgeInsetsMake(0, 10, 0, 10);
        _keyWindow = UIApplication.sharedApplication.keyWindow;
        _windowW = CGRectGetWidth(_keyWindow.bounds);
        _windowH = CGRectGetHeight(_keyWindow.bounds);
        _arrowWidth = 20;
        _arrowHeight = 10;
        _cornerRadius = 5;
        _contentInsets = UIEdgeInsetsZero;
        _showOffset = CGPointZero;
        _borderColor = UIColor.lightGrayColor;
        _maskColor = UIColor.clearColor;
    }
    return self;
}

- (void)showWithContentView:(UIView *)contentView sourceView:(UIView *)sourceView {
    CGFloat width = CGRectGetWidth(contentView.bounds) + _contentInsets.left + _contentInsets.right;
    CGFloat height = CGRectGetHeight(contentView.bounds) + _contentInsets.top + _contentInsets.bottom + _arrowHeight;
    CGRect sourceFrame = [sourceView convertRect:sourceView.bounds toView:_keyWindow];
    CGRect contentFrame = contentView.bounds;
    contentFrame.origin.x = _contentInsets.left;
    // 箭头顶点位置相对于keyWindow的坐标
    CGPoint arrowPoint_window;
    CGRect popoverFrame;
    if (_isUpward) {
        arrowPoint_window = CGPointMake(CGRectGetMidX(sourceFrame) + _showOffset.x, CGRectGetMaxY(sourceFrame) + _showOffset.y);
        popoverFrame = CGRectMake(arrowPoint_window.x - width / 2, arrowPoint_window.y, width, height);
        contentFrame.origin.y = _contentInsets.top + _arrowHeight;
    } else {
        arrowPoint_window = CGPointMake(CGRectGetMidX(sourceFrame) + _showOffset.x, CGRectGetMinY(sourceFrame) + _showOffset.y);
        popoverFrame = CGRectMake(arrowPoint_window.x - width / 2, arrowPoint_window.y - height, width, height);
        contentFrame.origin.y = _contentInsets.top;
    }
    if (CGRectGetMaxX(popoverFrame) + _margin_H.right > _windowW) {
        popoverFrame.origin.x = _windowW - _margin_H.right - width;
    }
    if (popoverFrame.origin.x < _margin_H.left) {
        popoverFrame.origin.x = _margin_H.left;
    }
    self.frame = popoverFrame;
    
    if (!_arrowSharp) {
        _arrowWidth += 6;
    }
    
    // 箭头顶点位置相对于当前视图(popoverView)的坐标
    CGPoint arrowPoint = [self convertPoint:arrowPoint_window fromView:_keyWindow];
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    if (_isUpward) {
        // ↖️左上圆角
        [maskPath moveToPoint:CGPointMake(0, _arrowHeight + _cornerRadius)];
        [maskPath addArcWithCenter:CGPointMake(_cornerRadius, _arrowHeight + _cornerRadius) radius:_cornerRadius startAngle:Radian(180) endAngle:Radian(270) clockwise:YES];
        // 箭头
        CGPoint arrowLeftPoint = CGPointMake(arrowPoint.x - _arrowWidth / 2, _arrowHeight);
        CGPoint arrowRightPoint = CGPointMake(arrowPoint.x + _arrowWidth / 2, _arrowHeight);
        [maskPath addLineToPoint:arrowLeftPoint];
        if (_arrowSharp) {
            // 尖角 箭头
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:arrowRightPoint];
        } else {
            // 圆角 箭头
            CGFloat controlPointX_left = (arrowLeftPoint.x + arrowPoint.x) / 2;
            [maskPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(controlPointX_left, arrowLeftPoint.y) controlPoint2:CGPointMake(controlPointX_left, arrowPoint.y)];
            CGFloat controlPointX_right = (arrowPoint.x + arrowRightPoint.x) / 2;
            [maskPath addCurveToPoint:arrowRightPoint controlPoint1:CGPointMake(controlPointX_right, arrowPoint.y) controlPoint2:CGPointMake(controlPointX_right, arrowRightPoint.y)];
        }
        // ↗️右上圆角
        [maskPath addLineToPoint:CGPointMake(width - _cornerRadius, _arrowHeight)];
        [maskPath addArcWithCenter:CGPointMake(width - _cornerRadius, _arrowHeight + _cornerRadius) radius:_cornerRadius startAngle:Radian(-90) endAngle:Radian(0) clockwise:YES];
        // ↘️右下圆角
        [maskPath addLineToPoint:CGPointMake(width, height - _cornerRadius)];
        [maskPath addArcWithCenter:CGPointMake(width - _cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:Radian(0) endAngle:Radian(90) clockwise:YES];
        // ↙️左下圆角
        [maskPath addLineToPoint:CGPointMake(_cornerRadius, height)];
        [maskPath addArcWithCenter:CGPointMake(_cornerRadius, height - _cornerRadius) radius:_cornerRadius startAngle:Radian(90) endAngle:Radian(180) clockwise:YES];
    } else {
        // ↖️左上圆角
        [maskPath moveToPoint:CGPointMake(0, _cornerRadius)];
        [maskPath addArcWithCenter:CGPointMake(_cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:Radian(180) endAngle:Radian(270) clockwise:YES];
        // ↗️右上圆角
        [maskPath addLineToPoint:CGPointMake(width - _cornerRadius, 0)];
        [maskPath addArcWithCenter:CGPointMake(width - _cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:Radian(-90) endAngle:Radian(0) clockwise:YES];
        // ↘️右下圆角
        [maskPath addLineToPoint:CGPointMake(width, height - _arrowHeight - _cornerRadius)];
        [maskPath addArcWithCenter:CGPointMake(width - _cornerRadius, height - _arrowHeight - _cornerRadius) radius:_cornerRadius startAngle:Radian(0) endAngle:Radian(90) clockwise:YES];
        // 箭头
        CGPoint arrowLeftPoint = CGPointMake(arrowPoint.x - _arrowWidth / 2, arrowPoint.y - _arrowHeight);
        CGPoint arrowRightPoint = CGPointMake(arrowPoint.x + _arrowWidth / 2, arrowPoint.y - _arrowHeight);
        [maskPath addLineToPoint:arrowRightPoint];
        if (_arrowSharp) {
            // 尖角 箭头
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:arrowLeftPoint];
        } else {
            // 圆角 箭头
            CGFloat controlPointX_right = (arrowPoint.x + arrowRightPoint.x) / 2;
            [maskPath addCurveToPoint:arrowPoint controlPoint1:CGPointMake(controlPointX_right, arrowRightPoint.y) controlPoint2:CGPointMake(controlPointX_right, arrowPoint.y)];
            CGFloat controlPointX_left = (arrowLeftPoint.x + arrowPoint.x) / 2;
            [maskPath addCurveToPoint:arrowLeftPoint controlPoint1:CGPointMake(controlPointX_left, arrowPoint.y) controlPoint2:CGPointMake(controlPointX_left, arrowLeftPoint.y)];
        }
        // ↙️左下圆角
        [maskPath addLineToPoint:CGPointMake(_cornerRadius, height - _arrowHeight)];
        [maskPath addArcWithCenter:CGPointMake(_cornerRadius, height - _arrowHeight - _cornerRadius) radius:_cornerRadius startAngle:Radian(90) endAngle:Radian(180) clockwise:YES];
    }
    [maskPath closePath];
    // 截取 圆角 和 箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.path = maskPath.CGPath;
    borderLayer.lineWidth = 1;
    borderLayer.fillColor = UIColor.clearColor.CGColor;
    borderLayer.strokeColor = _borderColor.CGColor;
    [self.layer addSublayer:borderLayer];
    // 添加ContentView
    contentView.frame = contentFrame;
    [self addSubview:contentView];
    // 往keyWindow上添加maskView
    UIView *maskView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    maskView.backgroundColor = _maskColor;
    maskView.alpha = 0;
    [_keyWindow addSubview:maskView];
    [maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    // 弹出动画
    [maskView addSubview:self];
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / width, _isUpward ? 0 : 1);
    self.frame = popoverFrame;
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        maskView.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.superview.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
