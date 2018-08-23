//
//  IMReviewView.h
//  Test
//
//  Created by 万涛 on 2018/6/15.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMRatingView.h"

@interface IMReviewView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet IMRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *negativeBtn;
@property (weak, nonatomic) IBOutlet UIButton *positiveBtn;

+ (instancetype)reviewView;

- (void)showWithTitle:(NSString *)title
                  msg:(NSString *)msg
          negativeStr:(NSString *)negativeStr
        negativeEvent:(void(^)(void))negativeEvent
          positiveStr:(NSString *)positiveStr
        positiveEvent:(void(^)(void))positiveEvent;

@end
