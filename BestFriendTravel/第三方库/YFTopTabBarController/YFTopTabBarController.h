//
//  YFTopTabBarController.h
//  TopTabBar
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 张玉飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFTopTabBarController : UIViewController
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIView *topTabBar;
-(void)addToParentViewController:(UIViewController *)viewController;
@end
