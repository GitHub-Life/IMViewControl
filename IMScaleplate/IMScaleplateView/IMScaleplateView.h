//
//  IMScaleplateView.h
//  IMScaleplateDemo
//
//  Created by 万涛 on 2018/7/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMScaleplateView;

@protocol IMScaleplateViewShowVolumeDelegate <NSObject>

- (void)scaleplateView:(IMScaleplateView *)scaleplateView currentVolume:(CGFloat)currentVolume;

@end

@interface IMScaleplateView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<IMScaleplateViewShowVolumeDelegate> delegate;

/** 视图与刻度线的 边距 */
@property (nonatomic, assign) IBInspectable UIEdgeInsets contentInsets;
/** 短刻度线 宽度 */
@property (nonatomic, assign) IBInspectable CGFloat shortScaleWidth;
/** 短刻度线 高度 */
@property (nonatomic, assign) IBInspectable CGFloat shortScaleHeight;
/** 长刻度线 宽度 */
@property (nonatomic, assign) IBInspectable CGFloat longScaleWidth;
/** 长刻度线 高度 */
@property (nonatomic, assign) IBInspectable CGFloat longScaleHeight;

/** 相邻短刻度线间距 */
@property (nonatomic, assign) IBInspectable CGFloat shortScaleInterval;
/** 相邻长刻度线间短刻度线的数量 */
@property (nonatomic, assign) IBInspectable NSInteger longScaleIntervalCount;

/** 绘制刻度线的颜色 */
@property (nonatomic, copy) IBInspectable UIColor *scaleColor;

/** 刻度线起始的值 */
@property (nonatomic, assign) IBInspectable CGFloat startVolume;
/** 刻度线终点的值 */
@property (nonatomic, assign) IBInspectable CGFloat endVolume;
/** 相邻短刻度线代表的值 */
@property (nonatomic, assign) IBInspectable CGFloat shortScaleVolume;
/** 绘制数字的颜色 */
@property (nonatomic, copy) IBInspectable UIColor *numberColor;
/** 绘制数字的字体 */
@property (nonatomic, copy) IBInspectable UIFont *numberFont;
/** 绘制数字保留的小数位数 */
@property (nonatomic, assign) IBInspectable int numberDecimals;

/** 是否有见面遮罩 */
@property (nonatomic, assign) IBInspectable BOOL gradientMask;

/**
 设置开始/结束绘制的刻度线索引值，方法调用即开始绘制
 @param startDrawScaleIndex 开始绘制的刻度线索引值
 @param endDrawScaleIndex 结束绘制的刻度线索引值
 */
- (void)setStartDrawScaleIndex:(NSInteger)startDrawScaleIndex endDrawScaleIndex:(NSInteger)endDrawScaleIndex;

/** 初始显示的值 */
@property (nonatomic, assign) CGFloat showInitVolume;

@property (nonatomic, assign) CGFloat currentVolume;

@end
