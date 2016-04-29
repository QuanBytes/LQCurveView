//
//  LQCurveMenuView.h
//  LQCurveView
//
//  Created by LiQuan on 16/4/29.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQCurveItemView.h"
#import "LQCurveMainView.h"

@interface LQCurveMenuView : UIView

@property (nonatomic ,copy)  NSArray * menuItems;

@property (nonatomic ,assign) NSInteger  progress;

@property (nonatomic ,assign) BOOL scale;

- (void)expend:(BOOL)isExpend ;

@end
