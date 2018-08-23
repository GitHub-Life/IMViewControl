//
//  IMReviewView.m
//  Test
//
//  Created by 万涛 on 2018/6/15.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "IMReviewView.h"

typedef void(^BtnClickEvent)(void);

@interface IMReviewView ()

@property (nonatomic, strong) BtnClickEvent negativeEvent;
@property (nonatomic, strong) BtnClickEvent positiveEvent;

@end

@implementation IMReviewView

+ (instancetype)reviewView {
    IMReviewView *reviewView = [[[UINib nibWithNibName:@"IMReviewView" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    __weak typeof(reviewView) weakReviewView = reviewView;
    [reviewView.ratingView setProgressChangedResult:^(CGFloat progress) {
        weakReviewView.positiveBtn.enabled = progress > 0;
    }];
    return reviewView;
}

- (void)showWithTitle:(NSString *)title msg:(NSString *)msg negativeStr:(NSString *)negativeStr negativeEvent:(void (^)(void))negativeEvent positiveStr:(NSString *)positiveStr positiveEvent:(void (^)(void))positiveEvent {
    if (self.superview) {
        return;
    }
    [_negativeBtn setTitle:negativeStr forState:UIControlStateNormal];
    [_positiveBtn setTitle:positiveStr forState:UIControlStateNormal];
    _negativeEvent = negativeEvent;
    _positiveEvent = positiveEvent;
    _titleLabel.text = title;
    _msgLabel.text = msg;
    
    self.alpha = 0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1;
    }];
}

- (void)dismiss {
    if (!self.superview) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (IBAction)negativeBtnClick {
    [self dismiss];
    if (_negativeEvent) {
        _negativeEvent();
    }
}

- (IBAction)positiveBtnClick {
    [self dismiss];
    if (_positiveEvent) {
        _positiveEvent();
    }
}

@end
