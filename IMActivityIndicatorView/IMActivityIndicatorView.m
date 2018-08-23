//
//  IMActivityIndicatorView.m
//  NiuYan
//
//  Created by 万涛 on 2018/3/28.
//  Copyright © 2018年 niuyan.com. All rights reserved.
//

#import "IMActivityIndicatorView.h"

@implementation IMActivityIndicatorView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initView];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"loading_circle@3x" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:gifPath];
    CGImageSourceRef imgSource = CGImageSourceCreateWithData(CFBridgingRetain(gifData), nil);
    NSMutableArray *imgs = [NSMutableArray array];
    NSTimeInterval totalDuration = 0;
    for (int i = 0; i < CGImageSourceGetCount(imgSource); i++) {
        CGImageRef cgImg = CGImageSourceCreateImageAtIndex(imgSource, i, nil);
        UIImage *img = [UIImage imageWithCGImage:cgImg];
        if (i == 0) {
            self.image = img;
        }
        [imgs addObject:img];
        
        NSDictionary *properties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imgSource, i, nil));
        NSTimeInterval frameDuration = [properties[(NSString *)kCGImagePropertyGIFDictionary][(NSString *)kCGImagePropertyGIFDelayTime] doubleValue];
        totalDuration += frameDuration;
    }
    self.animationImages = imgs;
    self.animationDuration = totalDuration;
    self.animationRepeatCount = 0;
}

- (void)show {
    self.alpha = 1;
    [self startAnimating];
}

- (void)dismiss {
    self.alpha = 0;
    [self stopAnimating];
}

@end
