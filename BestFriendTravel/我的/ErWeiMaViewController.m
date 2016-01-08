//
//  ErWeiMaViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/3.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import "QRCodeGenerator.h"//生成二维码
@interface ErWeiMaViewController ()

@end

@implementation ErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatErM];
    [self backSet];
}
-(void)creatErM{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageView.center=self.view.center;
    [self.view addSubview:imageView];
    //设置image
    imageView.image=[QRCodeGenerator qrImageForString:@"http://www.baidu.com" imageSize:300];
    
}
//设置返回按钮
-(void)backSet{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(10, 30, 80, 30);
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont systemFontOfSize:19];
    [self.view addSubview:backButton];
}
-(void)backButtonAction{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
