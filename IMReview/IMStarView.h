//
//  IMStarView.h
//  Test
//
//  Created by 万涛 on 2018/6/13.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMStarView : UIView

/** 绘制范围与View的边距 */
@property (nonatomic, assign) UIEdgeInsets starEdgeInsets;
/** 边框颜色 */
@property (nonatomic, copy) IBInspectable UIColor *starBorderColor;
/** 边框宽度 */
@property (nonatomic, assign) IBInspectable CGFloat starBorderWidth;
/** 填充色 */
@property (nonatomic, copy) IBInspectable UIColor *starFillColor;
/** 填充进度，从左至右 [0, 1] */
@property (nonatomic, assign) IBInspectable CGFloat progress;

@end
