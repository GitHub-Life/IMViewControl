//
//  IMScaleplateScrollView.h
//  IMScaleplateDemo
//
//  Created by 万涛 on 2018/7/19.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMScaleplateView.h"

@interface IMScaleplateScrollView : UIScrollView

@property (nonatomic, strong) IMScaleplateView *scaleplateView;

- (void)setStartVolume:(CGFloat)startVolume endVolume:(CGFloat)endVolume;

@property (nonatomic, assign) CGFloat showInitVolume;

@end
