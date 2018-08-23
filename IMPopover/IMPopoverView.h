//
//  IMPopoverView.h
//  IMPopover
//
//  Created by 万涛 on 2018/6/7.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMPopoverView : UIView

/** 箭头是否为尖角 */
@property (nonatomic, assign) BOOL arrowSharp;
/** 箭头宽 */
@property (nonatomic, assign) CGFloat arrowWidth;
/** 箭头高 */
@property (nonatomic, assign) CGFloat arrowHeight;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, assign) CGPoint showOffset;

@property (nonatomic, copy) UIColor *borderColor;

@property (nonatomic, copy) UIColor *maskColor;

/** 箭头朝向 YES:↑ NO:↓ */
@property (nonatomic, assign) BOOL isUpward;

- (void)showWithContentView:(UIView *)contentView sourceView:(UIView *)sourceView;

- (void)dismiss;

@end
