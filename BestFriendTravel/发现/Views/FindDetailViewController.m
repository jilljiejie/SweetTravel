//
//  FindDetailViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "FindDetailViewController.h"
#import "Common.h"
#import "UMSocial.h"
#import "FindCollectionManager.h"

#define UMENGKEY @"56458ae4e0f55ada37003cab"
@interface FindDetailViewController ()
@property(nonatomic,strong)UIButton *rightButton1;
@property(nonatomic,strong)UIButton *rightButton2;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation FindDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //将要出现时判断数据库内是否有进行过喜欢收藏
    FindCollectionManager *manager=[FindCollectionManager sharedFindCollectionManager];
    [manager isExistModelWith:self.productId withBlock:^(BOOL isblock) {
        if (isblock==YES) {
            //已经添加过喜欢
            self.rightButton1.selected=YES;
        }
        else{
        self.rightButton1.selected=NO;
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self customNav];
    
    UIWebView *web=[[UIWebView alloc]initWithFrame:self.view.bounds];
    NSString *path=self.productId;
    NSString *myPath=[NSString stringWithFormat:@"%@%@",FINDDETAIL_URL,path];
    NSURL *url=[NSURL URLWithString:myPath];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
    
}
-(void)customNav{
    self.navigationItem.title=@"体验详情";
    //设置左侧按钮
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftImage.image=[UIImage imageNamed:@"icon_back_button"];
    leftImage.userInteractionEnabled=YES;
    [leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftImage];
    //设置右侧按钮
    //喜欢
        _rightButton1=[UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton1.tag=200;
        _rightButton1.frame=CGRectMake(0, 0, 30, 30);
        [_rightButton1 setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
        [_rightButton1 setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateSelected];
        [_rightButton1 addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem1=[[UIBarButtonItem alloc]initWithCustomView:_rightButton1];
    //分享
        _rightButton2=[UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton2.tag=201;
        _rightButton2.frame=CGRectMake(0, 0, 30, 30);
        [_rightButton2 setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_rightButton2 addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem2=[[UIBarButtonItem alloc]initWithCustomView:_rightButton2];
    self.navigationItem.rightBarButtonItems=@[rightItem2,rightItem1];
}
#pragma mark---导航栏按钮的点击事件
//右侧按钮的点击事件
-(void)rightButtonAction:(UIButton *)button{
    NSLog(@"点击了。。。。。");
    NSInteger number=button.tag;
    if (number==200) {//点击了喜欢
        //判断是否添加过喜欢，如果没有,进行添加，如果有取消喜欢
        FindCollectionManager *manager=[FindCollectionManager sharedFindCollectionManager];
        [manager getAllModelsBlock:^(NSArray *modelArray) {
            [self.dataSource addObjectsFromArray:modelArray];
        }];
        if (self.rightButton1.selected==YES) {
            [manager deleteModelwithProductId:self.model.product_id];//去掉喜欢
        }
        else{
        [manager insertIntoModel:self.model];//没有添加过喜欢,进行添加
        }
        self.rightButton1.selected=!self.rightButton1.selected;
        
    }
    else{//点击了分享
        [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGKEY shareText:@"你要分享的文字" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToRenren,UMShareToDouban,UMShareToTwitter, nil] delegate:nil];
    }
}
//左侧按钮的点击事件
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---栏架载---
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
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
