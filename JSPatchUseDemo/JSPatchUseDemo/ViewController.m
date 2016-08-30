//
//  ViewController.m
//  JSPatchUseDemo
//
//  Created by beyondsoft-聂小波 on 16/8/30.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *crashBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [crashBtn setTitle:@"崩溃按钮" forState:UIControlStateNormal];
    [crashBtn addTarget:self action:@selector(crashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [crashBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:crashBtn];
    
    
    UIButton *normalBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50)];
    [normalBtn setTitle:@"正常按钮" forState:UIControlStateNormal];
    [normalBtn addTarget:self action:@selector(normalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [normalBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:normalBtn];
    
}

//崩溃按钮 的点击事件【崩溃测试，不写】，js里会重写此方法避免崩溃。
//- (void)crashBtnClick:(id)sender.

//正常按钮 的点击事件
- (void)normalBtnClick:(id)sender {
    SecondViewController *secVC = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:secVC animated:YES];
}

@end
