//
//  HeaderViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/24.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "HeaderViewController.h"
#import "MBProgressHUD.h"
@interface HeaderViewController ()
@property(nonatomic,strong)MBProgressHUD *hud;//等待提示
@end

@implementation HeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self customNav];
    [self.hud show:YES];
    UIWebView *web=[[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *path=self.url;
    NSURL *url=[NSURL URLWithString:path];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    [self.hud hide:YES];
}
-(void)customNav{
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
