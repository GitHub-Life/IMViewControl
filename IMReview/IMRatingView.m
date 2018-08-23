//
//  IMRatingView.m
//  Test
//
//  Created by 万涛 on 2018/6/13.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMRatingView.h"
#import "IMStarView.h"

typedef void(^IMProgressChangedEvent)(CGFloat);

@interface IMRatingView ()

@property (nonatomic, assign) CGFloat starWidth;

@property (nonatomic, strong) IMProgressChangedEvent progressChangedEvent;

@end

@implementation IMRatingView

- (void)setStarCount:(NSInteger)starCount {
    if (starCount <= 0) {
        starCount = 5;
    }
    _starCount = starCount;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    if (_starCount <= 0) {
        _starCount = 5;
    }
    _starWidth = CGRectGetWidth(rect) / (_starCount * 2);
    for (int i = 0; i < _starCount; i++) {
        IMStarView *starView = [[IMStarView alloc] initWithFrame:CGRectMake(_starWidth * 2 * i + _starWidth / 2, 0, _starWidth, CGRectGetHeight(rect))];
        starView.tag = i;
        starView.backgroundColor = _starBgColor ?: UIColor.clearColor;
        starView.starBorderWidth = _starBorderWidth;
        starView.starBorderColor = _starBorderColor;
        starView.starFillColor = _starFillColor;
        [self addSubview:starView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    self.progress = touchPoint.x / CGRectGetWidth(self.bounds);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    self.progress = touchPoint.x / CGRectGetWidth(self.bounds);
}

- (CGFloat)stepProgress {
    if (_starCount <= 0) {
        _starCount = 5;
    }
    if (_stepProgress <= 0) {
        _stepProgress = 1.0 / _starCount;
    }
    if (_stepProgress > 1) {
        _stepProgress = 1;
    }
    return _stepProgress;
}

- (void)setProgress:(CGFloat)progress {
    if (progress == _progress) return;
    if (_starCount <= 0) {
        _starCount = 5;
    }
    if (!self.subviews.count) return;
    if (progress < 0) progress = 0;
    if (progress > 1) progress = 1;
    progress = ceil(progress / self.stepProgress) * self.stepProgress;
    _progress = progress;
    CGFloat singleStarAreaRatio = _starWidth * 2 / CGRectGetWidth(self.bounds);
    for (IMStarView *star in self.subviews) {
        if (progress > singleStarAreaRatio) {
            star.progress = 1;
        } else {
            star.progress = progress * _starCount;
        }
        progress -= singleStarAreaRatio;
    }
    if (_progressChangedEvent) {
        _progressChangedEvent(_progress);
    }
}

- (void)setProgressChangedResult:(void (^)(CGFloat))prodressChangedResult {
    _progressChangedEvent = prodressChangedResult;
}

@end
