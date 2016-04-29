//
//  ViewController.m
//  LQCurveView
//
//  Created by LiQuan on 16/4/29.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

#import "ViewController.h"
#import "LQCurveMenuView.h"
#import "LQCurveItemView.h"

@interface ViewController ()
{
    LQCurveMenuView * main;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    main = [[LQCurveMenuView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:main];
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSInteger i =0 ; i < 5; i ++) {
        LQCurveItemView * view = [[LQCurveItemView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        view.backgroundColor = [UIColor redColor];
        [array addObject:view];
    }
    main.scale = YES;
    main.menuItems = array;
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 500, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}


static BOOL  isExpend = NO;
- (void)click
{
    main.progress = arc4random()%100;
    [main expend:!isExpend];
    isExpend = !isExpend;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

