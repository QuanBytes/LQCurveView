//
//  LQCurveMenuView.m
//  LQCurveView
//
//  Created by LiQuan on 16/4/29.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import "LQCurveMenuView.h"


@interface LQCurveMenuView ()

@property (nonatomic ,strong)LQCurveMainView * mainView;
@property (nonatomic ,assign)BOOL isExpend;
@property (nonatomic ,assign)CGPoint startPoint;
@property (nonatomic ,assign)CGFloat nearDistance;
@property (nonatomic ,assign)CGFloat farDistance;
@property (nonatomic ,assign)CGFloat endDistance;

@end


@implementation LQCurveMenuView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.mainView addGestureRecognizer:ges];
    
    self.startPoint = CGPointMake(self.frame.size.width /2, self.frame.size.height/2);
    self.nearDistance = 30;
    self.farDistance = 60;
    self.endDistance = 30;
    
}

- (void)tap
{
    self.isExpend = !self.isExpend;
    [self expend:self.isExpend];
}

- (void)setMenuItems:(NSArray *)menuItems
{
    
    if(_menuItems != menuItems)
    {
        _menuItems = menuItems;
        
        for (UIView * subView in menuItems) {
            if ([subView isKindOfClass:[LQCurveItemView class]]) {
                [subView removeFromSuperview];
            }
        }
        
        int count = (int)[menuItems count];
        CGFloat cnt = 1;
        for (int i = 0; i < count; i ++) {
            LQCurveItemView *item = [menuItems objectAtIndex:i];
            item.startPoint = self.startPoint;
            CGFloat pi =  M_PI / count;
            CGFloat endRadius = item.bounds.size.width / 2 + self.endDistance + _mainView.bounds.size.width / 2;
            CGFloat nearRadius = item.bounds.size.width / 2 + self.nearDistance + _mainView.bounds.size.width / 2;
            CGFloat farRadius = item.bounds.size.width / 2 + self.farDistance + _mainView.bounds.size.width / 2;
            item.endPoint = CGPointMake(self.startPoint.x + endRadius * sinf(pi * cnt),
                                        self.startPoint.y - endRadius * cosf(pi * cnt));
            item.nearPoint = CGPointMake(self.startPoint.x + nearRadius * sinf(pi * cnt),
                                         self.startPoint.y - nearRadius * cosf(pi * cnt));
            item.farPoint = CGPointMake(self.startPoint.x + farRadius * sinf(pi * cnt),
                                        self.startPoint.y - farRadius * cosf(pi * cnt));
            item.center = item.startPoint;
            item.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
            [self addSubview:item];
            
            cnt += 2;
        }
        
        [self bringSubviewToFront:_mainView];
    }
}


- (void)expend:(BOOL)isExpend {
    _isExpend = isExpend;
    [self.menuItems enumerateObjectsUsingBlock:^(LQCurveItemView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.scale) {
            if (isExpend) {
                obj.transform = CGAffineTransformIdentity;
            } else {
                obj.transform = CGAffineTransformMakeScale(0.001, 0.001);
            }
        }
        
        [self addRotateAndPostisionForItem:obj toShow:isExpend];
    }];
}


- (void)addRotateAndPostisionForItem:(LQCurveItemView *)item toShow:(BOOL)show {
    if (show) {
        CABasicAnimation *scaleAnimation = nil;
        if (self.scale) {
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0.2];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
            scaleAnimation.duration = 0.5f;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        }
        
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = @[@(M_PI), @(0.0)];
        rotateAnimation.duration = 0.5f;
        rotateAnimation.keyTimes = @[@(0.3), @(0.4)];
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
        CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        if (self.scale) {
            animationgroup.animations = @[scaleAnimation, positionAnimation, rotateAnimation];
        } else {
            animationgroup.animations = @[positionAnimation, rotateAnimation];
        }
        animationgroup.duration = 0.5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:animationgroup forKey:@"Expand"];
        item.center = item.endPoint;
    } else {
        CABasicAnimation *scaleAnimation = nil;
        if (self.scale) {
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:0.2];
            scaleAnimation.duration = 0.5f;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        }
        
        CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = @[@0, @(M_PI * 2), @(0)];
        rotateAnimation.duration = 0.5f;
        rotateAnimation.keyTimes = @[@0, @(0.4), @(0.5)];
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = 0.5f;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
        CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
        CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
        positionAnimation.path = path;
        CGPathRelease(path);
        
        CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
        if (self.scale) {
            animationgroup.animations = @[scaleAnimation, positionAnimation, rotateAnimation];
        } else {
            animationgroup.animations = @[positionAnimation, rotateAnimation];
        }
        
        animationgroup.duration = 0.5f;
        animationgroup.fillMode = kCAFillModeForwards;
        animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:animationgroup forKey:@"Close"];
        item.center = item.startPoint;
    }
}


- (LQCurveMainView *)mainView
{
    if (!_mainView) {
        _mainView = [[LQCurveMainView alloc]initWithFrame:self.bounds];
        [self addSubview:_mainView];
    }
    return _mainView;
}

- (void)setProgress:( NSInteger )progress
{
    _progress = progress;
    self.mainView.progress = progress;
}
@end