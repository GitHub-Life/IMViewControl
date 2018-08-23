//
//  ViewController.m
//  iOS_Radar
//
//  Created by Eccic on 16/7/25.
//  Copyright © 2016年 eccic. All rights reserved.
//

#import "ViewController.h"
#import "IMRadarView.h"

@interface ViewController ()

@property (nonatomic, strong) IMRadarView * scanRadarView;
@property (nonatomic, strong) IMRadarView * diffuseRadarView;

@property (weak, nonatomic) IBOutlet UIButton *rotateScanBtn;
@property (weak, nonatomic) IBOutlet UIButton *diffuseBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 扫描 类型 RadarView */
    _scanRadarView = [IMRadarView scanRadarViewWithRadius:self.view.bounds.size.height*0.5 angle:360 radarLineNum:5 hollowRadius:40];
    _scanRadarView.radarLineColor = [UIColor greenColor];
    _scanRadarView.startColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
    _scanRadarView.endColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0];
    
    /** 扩散 类型 RadarView */
    _diffuseRadarView = [IMRadarView diffuseRadarViewWithStartRadius:7 endRadius:self.view.bounds.size.height*0.5 circleColor:[UIColor whiteColor]];
}

- (IBAction)rotateScan:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (_diffuseBtn.selected) {
            _diffuseBtn.selected = NO;
            [_diffuseRadarView stopAnimation];
            [_diffuseRadarView dismiss];
        }
        [_scanRadarView showTargetView:self.view];
        [_scanRadarView startAnimatian];
        [self.view bringSubviewToFront:_diffuseBtn];
        [self.view bringSubviewToFront:_rotateScanBtn];
    } else {
        [_scanRadarView stopAnimation];
        [_scanRadarView dismiss];
    }
}

- (IBAction)diffuse:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (_rotateScanBtn.selected) {
            _rotateScanBtn.selected = NO;
            [_scanRadarView stopAnimation];
            [_scanRadarView dismiss];
        }
        
        [_diffuseRadarView showTargetView:self.view];
        [_diffuseRadarView startAnimatian];
        [self.view bringSubviewToFront:_rotateScanBtn];
        [self.view bringSubviewToFront:_diffuseBtn];
    } else {
        [_diffuseRadarView stopAnimation];
        [_diffuseRadarView dismiss];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
