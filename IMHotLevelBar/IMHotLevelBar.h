//
//  IMHotLevelBar.h
//  Test
//
//  Created by 万涛 on 2018/7/20.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IMHotLevelValueType) {
    IMHotLevelValueTypeOriginal = 0,  // 原始值
    IMHotLevelValueTypeFivePart,      // 5等分【步进0.2】
    IMHotLevelValueTypeTenPart        // 10等分【步进0.1】
};

@interface IMHotLevelBar : UIView

@property (nonatomic, assign) IMHotLevelValueType valueType;
@property (nonatomic, assign) IBInspectable NSInteger valueType_ib;

@property (nonatomic, assign) IBInspectable CGFloat percent;

@property (nonatomic, copy) IBInspectable UIColor *fireBgTintColor;

/** 未高亮的🔥是否显示 */
@property (nonatomic, assign) IBInspectable BOOL showFireBg;

@end
