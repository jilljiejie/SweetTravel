//
//  SplashViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/3.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "SplashViewController.h"
#import "FindViewController.h"
#import "DestinationViewController.h"
#import "SuggestViewController.h"
#import "MineViewController.h"
#import "MMDrawerController.h"//抽屉
#import "LeftViewController.h"
#import "ADView.h"//引导页
#import "AppDelegate.h"
#import "Reachability.h"//网络状态检测
@interface SplashViewController ()
@property(nonatomic,strong)Reachability *reach;
@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ifFirstBegin];
}
#pragma mark---判断用户是不是第一次启动app------
-(void)ifFirstBegin{
    if ([self isFirstStarApp]==YES) {
        //用户第一启动app，需要展示引导页
        [self showGuide];
    }
    else{
        //直接进入界面
        //判断有没有网
        if ([self.reach currentReachabilityStatus]!=NotReachable) {
            [self customViews];//有网进入界面
        }
        else{//没网，弹出提示
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"网络错误" message:@"请检查您的网络连接状态" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    }
}
//判断是不是第一次启动app
-(BOOL)isFirstStarApp{
    //获得单例
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    //读取用户上一次启动app的次数
    NSString *number=[userDefault objectForKey:@"number"];
    if (number!=nil) {
        //能够取到值说明不是第一次启动
        NSInteger starNumber=[number integerValue];
        //上一次的此时+1
        NSString *str=[NSString stringWithFormat:@"%ld",++starNumber];
        //存用户启动的次数
        [userDefault setObject:str forKey:@"number"];
        [userDefault synchronize];
        return NO;
    }
    else{//不能取到值说明是第一次启动
        [userDefault setObject:@"1" forKey:@"number"];
        [userDefault synchronize];
        return YES;
        
    }
}
#pragma mark---展示引导页-----
-(void)showGuide{
    NSArray *imageArray=@[@"guide1.jpg",@"guide2.jpg",@"guide3.jpg"];
    ADView *adView=[[ADView alloc]initWithArray:imageArray andFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) andBlock:^{
        [self customViews];
    }];
    [self.view addSubview:adView];
}
#pragma mark-----展示app界面------
-(void)customViews{
    //推荐
    SuggestViewController *suggest=[[SuggestViewController alloc]init];
    UINavigationController *suggestNav=[[UINavigationController alloc]initWithRootViewController:suggest];
    suggest.title=@"推荐";
    suggestNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"推荐" image:[[UIImage imageNamed:@"iconfont-tuijian"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"iconfont-tuijian-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //发现
    FindViewController *find=[[FindViewController alloc]init];
    find.title=@"发现";
    UINavigationController *findNav=[[UINavigationController alloc]initWithRootViewController:find];
    findNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"发现" image:[[UIImage imageNamed:@"find0@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"find@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //目的地
    DestinationViewController *destination=[[DestinationViewController alloc]init];
    destination.title=@"目的地";
    UINavigationController *desNav=[[UINavigationController alloc]initWithRootViewController:destination];
    desNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"目的地" image:[[UIImage imageNamed:@"mudidi0@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"mudidi@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //我的
    LeftViewController *leftVc=[[LeftViewController alloc]init];
    MineViewController *mine=[[MineViewController alloc]init];
    mine.title=@"我的";
    UINavigationController *mineNav=[[UINavigationController alloc]initWithRootViewController:mine];
    mineNav.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"iconfont-wode-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"iconfont-wode-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    MMDrawerController *mmDrawerVc=[[MMDrawerController alloc]initWithCenterViewController:mineNav leftDrawerViewController:leftVc];
    //设置打开和关闭的手势
    mmDrawerVc.openDrawerGestureModeMask=MMOpenDrawerGestureModeAll;
    mmDrawerVc.closeDrawerGestureModeMask=MMCloseDrawerGestureModeAll;
    //设置左边视图控制器显示的宽度
    mmDrawerVc.maximumLeftDrawerWidth=200;
    
    mmDrawerVc.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"iconfont-wode-3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"iconfont-wode-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    UITabBarController *tabVc=[[UITabBarController alloc]init];
    tabVc.viewControllers=@[suggestNav,desNav,findNav,mmDrawerVc];
    
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController=tabVc;
    
}

#pragma mark---懒加载---
-(Reachability *)reach{
    if (!_reach) {
        _reach=[Reachability reachabilityForInternetConnection];
    }
    return _reach;
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
