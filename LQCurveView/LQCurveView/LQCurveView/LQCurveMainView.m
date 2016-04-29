//
//  LQCurveMainView.m
//  LQCurveView
//
//  Created by LiQuan on 16/4/29.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import "LQCurveMainView.h"
#define KLineWidth 10

@interface LQCurveMainView()

@property (nonatomic, strong) CAShapeLayer * outLayer;
@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, strong) UILabel      * percentLabel;

@end

@implementation LQCurveMainView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawLayer];
    }
    return self;
}
#define   kDegreesToRadians(degrees)  ((pi * degrees)/ 180)
- (void)drawLayer
{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.outLayer = [CAShapeLayer layer];
    CGRect rect   = CGRectMake(KLineWidth / 2, KLineWidth / 2, width - KLineWidth, height - KLineWidth);
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:rect];
    self.outLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.outLayer.lineWidth = KLineWidth;
    self.outLayer.fillColor = [UIColor clearColor].CGColor;
    self.outLayer.lineCap   = kCALineCapRound;
    self.outLayer.lineJoin  = kCALineJoinRound;
    self.outLayer.path      = path.CGPath;
    [self.layer addSublayer:self.outLayer];
    
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = self.bounds;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = KLineWidth;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.path = path.CGPath;
    
    
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, width / 2, height);
    CGColorRef red = [UIColor redColor].CGColor;
    CGColorRef purple = [UIColor purpleColor].CGColor;
    CGColorRef yellow = [UIColor yellowColor].CGColor;
    CGColorRef orange = [UIColor orangeColor].CGColor;
    [gradientLayer1 setColors:@[(__bridge id)red, (__bridge id)purple, (__bridge id)yellow, (__bridge id)orange]];
    [gradientLayer1 setLocations:@[@0.3, @0.6, @0.8, @1.0]];
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(width / 2, 0, width / 2, height);
    CGColorRef blue = [UIColor brownColor].CGColor;
    CGColorRef purple1 = [UIColor purpleColor].CGColor;
    CGColorRef r1 = [UIColor yellowColor].CGColor;
    CGColorRef o1 = [UIColor orangeColor].CGColor;
    [gradientLayer2 setColors:@[(__bridge id)blue, (__bridge id)purple1, (__bridge id)r1, (__bridge id)o1]];
    [gradientLayer2 setLocations:@[@0.3, @0.6, @0.8, @1.0]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer addSublayer:gradientLayer1];
    [gradientLayer1 addSublayer:gradientLayer2];
    gradientLayer.mask = self.progressLayer;
    [self.layer addSublayer:gradientLayer];
}



- (void)setProgress:( NSUInteger )progress
{
    _progress = progress;
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:0.5];
    self.progressLayer.strokeEnd =  progress / 100.0;
    self.percentLabel.text = [NSString stringWithFormat:@"%@%%", @(progress)];
    [CATransaction commit];
}

- (UILabel *)percentLabel
{
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2 , self.frame.size.height/2)];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.textColor = [UIColor blackColor];
        _percentLabel.adjustsFontSizeToFitWidth = YES;
        _percentLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2);
        [self addSubview:_percentLabel];
    }
    return _percentLabel;
}

@end

