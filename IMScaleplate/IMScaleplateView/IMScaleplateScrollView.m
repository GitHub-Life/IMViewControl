//
//  IMScaleplateScrollView.m
//  IMScaleplateDemo
//
//  Created by 万涛 on 2018/7/19.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMScaleplateScrollView.h"

@implementation IMScaleplateScrollView

- (IMScaleplateView *)scaleplateView {
    if (!_scaleplateView) {
        _scaleplateView = [[IMScaleplateView alloc] init];
    }
    return _scaleplateView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSetting];
    }
    return self;
}

- (void)initSetting {
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    [self addSubview:self.scaleplateView];
    self.delegate = self.scaleplateView;
    CGFloat width = CGRectGetWidth(self.bounds);
    self.scaleplateView.contentInsets = UIEdgeInsetsMake(0, width / 2, 0, width / 2);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    self.scaleplateView.contentInsets = UIEdgeInsetsMake(0, width / 2, 0, width / 2);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.scaleplateView.backgroundColor = backgroundColor;
}

- (void)setStartVolume:(CGFloat)startVolume endVolume:(CGFloat)endVolume {
    if (endVolume < startVolume) {
        return;
    }
    NSInteger startScale = floor(startVolume / (self.scaleplateView.shortScaleVolume * self.scaleplateView.longScaleIntervalCount));
    NSInteger endScale = ceil(endVolume / (self.scaleplateView.shortScaleVolume * self.scaleplateView.longScaleIntervalCount));
    
    self.scaleplateView.startVolume = startScale * (self.scaleplateView.shortScaleVolume * self.scaleplateView.longScaleIntervalCount);
    self.scaleplateView.endVolume = endScale * (self.scaleplateView.shortScaleVolume * self.scaleplateView.longScaleIntervalCount);
    
    CGFloat startScaleX = startScale * (self.scaleplateView.shortScaleInterval * self.scaleplateView.longScaleIntervalCount);
    CGFloat endScaleX = endScale * (self.scaleplateView.shortScaleInterval * self.scaleplateView.longScaleIntervalCount);
    CGFloat drawTotalWidth = endScaleX - startScaleX;
    self.scaleplateView.frame = CGRectMake(0, 0, drawTotalWidth + self.scaleplateView.contentInsets.left + self.scaleplateView.contentInsets.right, CGRectGetHeight(self.bounds));
    self.contentSize = self.scaleplateView.bounds.size;
    [self.scaleplateView scrollViewDidScroll:self];
}

- (void)setShowInitVolume:(CGFloat)showInitVolume {
    if (showInitVolume < self.scaleplateView.startVolume) {
        showInitVolume = self.scaleplateView.startVolume;
    }
    if (showInitVolume > self.scaleplateView.endVolume) {
        showInitVolume = self.scaleplateView.endVolume;
    }
    _showInitVolume = showInitVolume;
    self.scaleplateView.showInitVolume = showInitVolume;
    CGFloat x = (showInitVolume - self.scaleplateView.startVolume) / self.scaleplateView.shortScaleVolume * self.scaleplateView.shortScaleInterval + self.scaleplateView.contentInsets.left;
    [self setContentOffset:CGPointMake(x - CGRectGetWidth(self.bounds) / 2, 0)];
}

@end
