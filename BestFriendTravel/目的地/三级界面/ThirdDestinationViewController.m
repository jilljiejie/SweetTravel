//
//  ThirdDestinationViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ThirdDestinationViewController.h"
#import "ThirdDesTableViewCell.h"
#import "ThirdDestinationModel.h"
#import "Common.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ForthDestinationViewController.h"
#import "ThirdTwoDesModel.h"
#import "ThirdTwoDesTableViewCell.h"
#import "TravelWriteViewController.h"
#import "UMSocial.h"
#define UMENGKEY @"56458ae4e0f55ada37003cab"
@interface ThirdDestinationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *talkArr;
@property(nonatomic,strong)NSMutableArray *outSource;//最外层的数据
@property(nonatomic,strong)UIButton *rightButton;//分享按钮
@end

@implementation ThirdDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createTableView];
    [self createNav];
    self.navigationItem.title=self.name;
}
#pragma mark---设计返回按钮和分享按钮-----
//设计返回按钮和分享按钮
-(void)createNav{
    //左边的返回按钮
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftImage.image=[UIImage imageNamed:@"icon_back_button"];
    leftImage.userInteractionEnabled=YES;
    [leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftImage];
    //右边的分享按钮
    _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.tag=201;
    _rightButton.frame=CGRectMake(0, 0, 30, 30);
    [_rightButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
//返回上一页面
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
//分享
-(void)rightButtonAction{
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGKEY shareText:@"你要分享的文字" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToRenren,UMShareToDouban,UMShareToTwitter, nil] delegate:nil];
    
}
#pragma mark---tableView相关----
-(void)createTableView{
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor whiteColor];
    //去掉多余的线
    self.tableView.tableFooterView=[[UIView alloc]init];
    //设置头视图
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 260)];
    //上面的图片
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
    UIImageView *headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    headerImageView.userInteractionEnabled=YES;
    [headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageAction)]];
    [headerView addSubview:headerImageView];
    [bgView addSubview:headerView];
    //设置下面的分类(游记，讨论)
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_W, 60)];
    bottomView.backgroundColor=[UIColor whiteColor];
    float width=SCREEN_W/2;
    NSArray *titleArr=@[@"游记",@"讨论"];
    NSArray *titleImage=@[@"activity_grid_item_content_new_10@2x",@"MoreGame@2x"];
    for (int i=0; i<2; i++) {
        UIView *buttonView=[[UIView alloc]initWithFrame:CGRectMake(i*width, 0, width, 60)];
        buttonView.layer.borderWidth=0.3;
        buttonView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        //设置button
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, width, 40);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=100+i;
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        //设置图片
        [button setImage:[UIImage imageNamed:titleImage[i]] forState:UIControlStateNormal];
        [buttonView addSubview:button];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, width, 20)];
        label.text=titleArr[i];
        label.font=[UIFont systemFontOfSize:13];
        label.textAlignment=NSTextAlignmentCenter;
        [buttonView addSubview:label];
        [bottomView addSubview:buttonView];
    }
    [bgView addSubview:bottomView];
    self.tableView.tableHeaderView=bgView;
}
#pragma mark---点击事件---
//头视图图片的点击事件
-(void)headerImageAction{

}
//头视图下面按钮的点击事件
-(void)buttonAction:(UIButton *)button{
    NSInteger number=button.tag-100;
    if (number==1) {
        ForthDestinationViewController *forth=[[ForthDestinationViewController alloc]init];
        forth.talkArr=self.talkArr;
        [self.navigationController pushViewController:forth animated:YES];
    }
    else {
        TravelWriteViewController *travel=[[TravelWriteViewController alloc]init];
        travel.cityId=self.cityId;
        [self.navigationController pushViewController:travel animated:YES];
    }
}
#pragma mark--------请求数据
-(void)loadData{
    //请求描述文字
    NSString *path=[NSString stringWithFormat:ROUTTHIRD_URL,self.cityId];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        ThirdDestinationModel *model=[[ThirdDestinationModel alloc]init];
        model.detail=dic[@"detail"];
        model.destination=dic[@"destination"];
        if (dic[@"name"]) {
            model.name=dic[@"name"];
        }
        
        [self.dataSource addObject:model];
        [self.outSource addObject:self.dataSource];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    //请求讨论区的内容
    NSString *cityPath=[NSString stringWithFormat:ROUTTALK_URL,self.cityId,self.cityId];
    AFHTTPRequestOperationManager *manager2=[AFHTTPRequestOperationManager manager];
    manager2.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager2 GET:cityPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *postsArr=dic[@"posts"];
        for (NSDictionary *postsDic in postsArr) {
            ThirdTwoDesModel *model=[[ThirdTwoDesModel alloc]init];
            model.content=postsDic[@"content"];
            model.trail_title=postsDic[@"trail_title"];
            NSDictionary *createdByDic=postsDic[@"created_by"];
            model.avatar=createdByDic[@"avatar"];
            model.nickname=createdByDic[@"nickname"];
            [self.talkArr addObject:model];
        }
        [self.outSource addObject:self.talkArr];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
//    [self createTableView];
    
}
#pragma mark----tableView协议方法------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.outSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else{
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *reuseID=@"reuse id";
        ThirdDesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell=[[ThirdDesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        cell.model=self.outSource[indexPath.section][indexPath.row];
        return cell;
    }
    else{
        static NSString *reuID=@"reusetwo id";
        ThirdTwoDesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuID];
        if (!cell) {
            cell=[[ThirdTwoDesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuID];
        }
        cell.model=self.outSource[indexPath.section][indexPath.row];
        return cell;
    
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *reuseID=@"reuse id";
        ThirdDesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
        if (!cell) {
            cell=[[ThirdDesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        cell.model=self.outSource[indexPath.section][indexPath.row];
        return cell.maxY+10;
    }
    else{
        static NSString *reuID=@"reusetwo id";
        ThirdTwoDesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuID];
        if (!cell) {
            cell=[[ThirdTwoDesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuID];
        }
        if (self.outSource)
        {
            cell.model=self.outSource[indexPath.section][indexPath.row];
        }
        
        return cell.maxY+10;
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    else
        return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
        headerView.backgroundColor=[UIColor whiteColor];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 30)];
        label.text=@"讨论区";
        label.textColor=[UIColor grayColor];
        label.font=[UIFont systemFontOfSize:18];
        [headerView addSubview:label];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 20, 20)];
        imageView.image=[UIImage imageNamed:@"iconfont-ribaotaolun"];
        [headerView addSubview:imageView];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"更多" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        button.frame=CGRectMake(SCREEN_W-5-50, 0, 50, 30);
        [button addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        return headerView;
    }
    else
        return nil;
}
#pragma mark--更多button的点击方法
-(void)moreButtonAction{
    ForthDestinationViewController *forth=[[ForthDestinationViewController alloc]init];
    forth.talkArr=self.talkArr;
    [self.navigationController pushViewController:forth animated:YES];
}
#pragma mark----懒加载-----
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)talkArr{
    if (!_talkArr) {
        _talkArr=[[NSMutableArray alloc]init];
    }
    return _talkArr;
}
-(NSMutableArray *)outSource{
    if (!_outSource) {
        _outSource=[[NSMutableArray alloc]init];
    }
    return _outSource;
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
