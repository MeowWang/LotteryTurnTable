//
//  ViewController.m
//  WHOgets6
//
//  Created by 王雪利 on 15/8/24.
//  Copyright (c) 2015年 王雪利. All rights reserved.
//

#import "ViewController.h"
#import "TurnTableView.h"

@interface ViewController ()
{
    double _startValue;
}
@property (nonatomic, strong)TurnTableView *turnTableView;
@property (nonatomic, strong)UIImageView *pointer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _startValue = 0;
    //旋转转盘用到了随机数，这里获取时间作为种子
    srand((unsigned)time(0));

    UIColor *color= [UIColor colorWithRed:115/255.0 green:172/255.0 blue:42/255.0 alpha:1];
    [self.view setBackgroundColor:color];
    
    [self setUpUI];
}

-(void)dealloc
{
    self.turnTableView = nil;
    self.pointer = nil;
}

- (void)setUpUI
{
    NSDictionary *dataDic = [NSDictionary
                             dictionaryWithObjectsAndKeys:
                             @(1),@"Jamie",
                             @(1),@"Cercie",
                             @(1),@"Joffery",
                             @(2),@"Imp",
                             @(1),@"Ned",
                             @(3),@"Arya",
                             @(2),@"Shae",
                             @(1),@"Sansa",
                             @(3),@"Margaery",
                             @(2),@"Baelish",
                             nil];
    
    //设置转盘
    self.turnTableView = [[TurnTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.width - 40)withData:dataDic];
    
    [self.turnTableView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 60)];
    [self.turnTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.turnTableView];
    
    //设置红色指针
    self.pointer = [[UIImageView alloc]initWithFrame:CGRectMake(self.turnTableView.center.x + 60, 0, self.turnTableView.frame.size.width/2, 10)];
    [self.pointer setCenter:CGPointMake(self.pointer.center.x, self.turnTableView.center.y)];
    [self.pointer setImage:[UIImage imageNamed:@"red.png"]];
    [self.pointer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.pointer];
    
    UIColor *color2= [UIColor colorWithRed:250/255.0 green:182/255.0 blue:64/255.0 alpha:1];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
    btn.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+140);
    [btn setBackgroundColor:color2];
    [btn setTitle:@"WHO？!" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(turnTheTable) forControlEvents:UIControlEventTouchUpInside];
    
    //设置按钮圆角
    [btn.layer setCornerRadius:10];
    [self.view addSubview:btn];
}

- (void)turnTheTable
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//z的意思是绕z轴旋转，此处的z轴是垂直于iPhone，正方向从背面指向屏幕前方
    double endValue = _startValue+(rand()%100)/100.0 * M_PI + M_PI*(rand()%5+5); //这里的endValue单位是弧度，2PI是一圈
    
    //设置旋转的起始值与终止值
    rotationAnimation.fromValue = @(_startValue);
    rotationAnimation.toValue = @(endValue);
    
    //旋转时长
    rotationAnimation.duration = (endValue - _startValue)/(M_PI*2);
    rotationAnimation.autoreverses = NO;
    
    //速度函数
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBoth;
    [self.turnTableView.layer addAnimation:rotationAnimation forKey:@"TurnTableAnimation"];
    
    //记下当前旋转的位置，作为下一次旋转的起始值
    _startValue = endValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
