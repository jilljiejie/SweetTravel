//
//  BaseViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/24.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"guest_bar"] forBarMetrics:UIBarMetricsDefault];
    //设置导航栏的字体颜色
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    //设置tabbar字体颜色
    self.tabBarController.tabBar.tintColor=[UIColor colorWithRed:0/255.f green:189/255.f blue:169/255.f alpha:1];
    //设置tabbar背景颜色
    [self.tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
