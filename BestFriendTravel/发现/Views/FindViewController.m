//
//  FindViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/24.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "FindViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FindMainModel.h"
#import "FindAllTableViewCell.h"
#import "Common.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "FindDetailViewController.h"
#import "SearchViewController.h"
#import "ChoseViewController.h"
@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CLLocationDegrees _latitude;//纬度
    CLLocationDegrees _longitude;//经度
}

@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int Start;
@property(nonatomic,strong)UIButton *button;//导航左边的按钮
@property(nonatomic,strong)UIButton *rightButton;//导航右边的按钮
@property(nonatomic,strong)MBProgressHUD *hud;//等待提示
@end

@implementation FindViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏的左右按钮
    [self creatNav];
    [self creatTableView];
    [self loadData];
}
-(void)creatTableView{
    //tableView相关
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //设置代理
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"FindAllTableViewCell" bundle:nil] forCellReuseIdentifier:@"findCell"];
    [self.view addSubview:_tableView];
    //去掉分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //下拉刷新和上拉加载
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    //立即刷新
    [self.tableView.header beginRefreshing];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreData];
    }];

}
#pragma mark---设置导航栏的左右按钮-----
-(void)creatNav{
    //左按钮
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    _button=[UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame=CGRectMake(10,0,70, 30);
    [_button addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"北京" forState:UIControlStateNormal];
    _button.titleLabel.textAlignment=NSTextAlignmentLeft;
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font=[UIFont systemFontOfSize:16];
    [view addSubview:_button];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
    imageView.image=[UIImage imageNamed:@"iconfont-xiangxia"];
    imageView.userInteractionEnabled=YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonAction)]];
    [view addSubview:imageView];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:view];
    //右按钮
    _rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"iconfont-ditu"] forState:UIControlStateNormal];
    _rightButton.titleLabel.font=[UIFont systemFontOfSize:16];
    _rightButton.frame=CGRectMake(0, 0, 60, 30);
    [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_rightButton];

}
#pragma mark---左边搜索按钮的响应事件---
//左边搜索按钮响应方法
-(void)leftButtonAction{
    SearchViewController *search=[[SearchViewController alloc]init];
    search.backStringBlock=^(NSString *str){
        [_hud show:YES];
        [_button setTitle:str forState:UIControlStateNormal];
        [self requestData];
        [_hud hide:YES];
    };
    search.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:search animated:YES];
}
#pragma mark---右边定位按钮的响应事件---
-(void)rightAction{
    ChoseViewController *chose=[[ChoseViewController alloc]init];
    chose.hidesBottomBarWhenPushed=YES;
    chose.cityName=self.button.titleLabel.text;
    [self.navigationController pushViewController:chose animated:YES];
}
-(void)requestData{
    _Start=0;
    [self loadData];
}
-(void)requestMoreData{
    _Start++;
    [self loadData];
}
#pragma mark ----请求数据-----
//请求数据
-(void)loadData{
    NSString *path=[NSString stringWithFormat:FINDCHOSE_URL,_Start,self.button.titleLabel.text];
    //路径中含有中文，进行转义
    NSString *utfPath=[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager GET:utfPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array=dic[@"product_list"];
        if (_Start==0) {
            [self.dataSource removeAllObjects];
        }
        for (NSDictionary *dd in array) {
            FindMainModel *model=[[FindMainModel alloc]init];
            model.address=dd[@"address"];
            model.date_str=dd[@"date_str"];
            model.like_conut=dd[@"like_count"];
            model.price=dd[@"price"];
            model.title=dd[@"title"];
            model.title_page=dd[@"title_page"];
            model.product_id=dd[@"product_id"];
            NSDictionary *dict=dd[@"user"];
            model.avatar_l=dict[@"avatar_l"];
            model.name=dict[@"name"];
            NSArray *tabArr=dd[@"tab_list"];
            model.tab_list=tabArr.firstObject;
            [self.dataSource addObject:model];
        }
        if (_Start==0) {//结束下拉刷新
            [self.tableView.header endRefreshing];
        }
        else{//结束上拉加载
            [self.tableView.footer endRefreshing];
        }
        //刷新数据
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark----TableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
//设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindAllTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"findCell" forIndexPath:indexPath];
    FindMainModel *model=self.dataSource[indexPath.row];
    
    [cell.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.title_page]];
    [cell.littleImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar_l]];
    cell.titleLabel.text=model.title;
    cell.priceLabel.text=[NSString stringWithFormat:@"￥%@",model.price];
    cell.tab_listLabel.text=model.tab_list;
    cell.dateAddressLikeLabel.text=[NSString stringWithFormat:@"%@  %@  %@人喜欢",model.date_str,model.address,model.like_conut];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 271;
}
//点击某行的响应方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FindDetailViewController *find=[[FindDetailViewController alloc]init];
    FindMainModel *model=self.dataSource[indexPath.row];
    find.productId=model.product_id;
    find.model=model;
    find.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:find animated:YES];
}
#pragma mark---懒加载----
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(MBProgressHUD *)hud{
    if (!_hud) {
        _hud=[[MBProgressHUD alloc]initWithView:self.view];
        _hud.tintColor=[UIColor colorWithRed:186/255.f green:245/255.f blue:255/155.f alpha:1];
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
