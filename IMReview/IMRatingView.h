//
//  IMRatingView.h
//  Test
//
//  Created by 万涛 on 2018/6/13.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMRatingView : UIView

@property (nonatomic, assign) IBInspectable NSInteger starCount;

/** 边框颜色 */
@property (nonatomic, copy) IBInspectable UIColor *starBorderColor;
/** 边框宽度 */
@property (nonatomic, assign) IBInspectable CGFloat starBorderWidth;
/** 填充色 */
@property (nonatomic, copy) IBInspectable UIColor *starFillColor;
/** 背景色 */
@property (nonatomic, copy) IBInspectable UIColor *starBgColor;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) IBInspectable CGFloat stepProgress;

- (void)setProgressChangedResult:(void(^)(CGFloat progress))prodressChangedResult;

@end
