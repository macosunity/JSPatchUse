//
//  SecondViewController.m
//  JSPatchUseDemo
//
//  Created by beyondsoft-聂小波 on 16/8/30.
//  Copyright © 2016年 NieXiaobo. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *crashBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [crashBtn setTitle:@"崩溃按钮" forState:UIControlStateNormal];
    [crashBtn addTarget:self action:@selector(crashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [crashBtn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:crashBtn];
    
}

//崩溃按钮 的点击事件【崩溃测试，不写】，js里会重写此方法避免崩溃。
//- (void)crashBtnClick:(id)sender.

@end
