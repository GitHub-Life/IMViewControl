//
//  ViewController.m
//  IMScaleplateDemo
//
//  Created by 万涛 on 2018/7/18.
//  Copyright © 2018年 iMoon. All rights reserved.
//

#import "ViewController.h"
#import "IMScaleplateScrollView.h"

@interface ViewController () <IMScaleplateViewShowVolumeDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic, strong) IMScaleplateScrollView *scaleplateScrollView;

@property (weak, nonatomic) IBOutlet UILabel *valueLabel1;
@property (weak, nonatomic) IBOutlet IMScaleplateScrollView *scaleplateScrollView1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _scaleplateScrollView = [[IMScaleplateScrollView alloc] initWithFrame:_containerView.bounds];
    _scaleplateScrollView.tag = 1;
    [_containerView addSubview:_scaleplateScrollView];
    _scaleplateScrollView.scaleplateView.delegate = self;
    _scaleplateScrollView.backgroundColor = UIColor.blueColor;
    _scaleplateScrollView.scaleplateView.scaleColor = UIColor.whiteColor;
    _scaleplateScrollView.scaleplateView.shortScaleVolume = 10.f;
    [_scaleplateScrollView setStartVolume:47.5 endVolume:919];
    _scaleplateScrollView.showInitVolume = 777;
    
    _scaleplateScrollView1.scaleplateView.delegate = self;
    _scaleplateScrollView1.backgroundColor = UIColor.blackColor;
    _scaleplateScrollView1.scaleplateView.scaleColor = UIColor.whiteColor;
    _scaleplateScrollView1.scaleplateView.numberDecimals = 1;
    _scaleplateScrollView1.scaleplateView.shortScaleVolume = 10.f;
    _scaleplateScrollView1.scaleplateView.shortScaleInterval = 15.f;
    _scaleplateScrollView1.scaleplateView.shortScaleHeight = 10.f;
    _scaleplateScrollView1.scaleplateView.longScaleHeight = 15.f;
    _scaleplateScrollView1.scaleplateView.gradientMask = YES;
    [_scaleplateScrollView1 setStartVolume:47.5 endVolume:9919];
    _scaleplateScrollView1.showInitVolume = 777;
}

#pragma mark - IMScaleplateViewShowVolume Delegate
- (void)scaleplateView:(IMScaleplateView *)scaleplateView currentVolume:(CGFloat)currentVolume {
    if (scaleplateView == self.scaleplateScrollView.scaleplateView) {
        _valueLabel.text = [NSString stringWithFormat:@"%.0f", currentVolume];
    } else if (scaleplateView == self.scaleplateScrollView1.scaleplateView) {
        _valueLabel1.text = [NSString stringWithFormat:@"%.1f", currentVolume];
    }
}

@end
