//
//  ShowDetailViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ShowDetailViewController.h"
#import "Common.h"
#import "MBProgressHUD.h"
@interface ShowDetailViewController ()
@property(nonatomic,strong)MBProgressHUD *hud;
@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.hud show:YES];
    [self createNav];
    //webView相关
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    NSURL *myUrl=[NSURL URLWithString:self.url];
    NSURLRequest *request=[NSURLRequest requestWithURL:myUrl];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    [self.hud hide:YES];
}
//设计返回按钮
-(void)createNav{
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftImage.image=[UIImage imageNamed:@"icon_back_button"];
    leftImage.userInteractionEnabled=YES;
    [leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftImage];
}
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(MBProgressHUD *)hud{
    if (!_hud) {
        _hud=[[MBProgressHUD alloc]initWithView:self.view];
        _hud.labelText=@"正在加载";
        [self.view addSubview:_hud];
    }
    return _hud;
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
