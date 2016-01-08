//
//  SecondTopicViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "SecondTopicViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DesDetailTableViewCell.h"
#import "DesDetailModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "ThirdDestinationViewController.h"
@interface SecondTopicViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)int page;


@end

@implementation SecondTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=self.name;
    [self createTableView];
    [self loadData];
    [self createNav];
    
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

#pragma mark---tableView相关----
-(void)createTableView{
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //    _tableView.backgroundColor=[UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"DesDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"desDetail"];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    //去掉分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //上拉加载和下拉刷新
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    //立即刷新
    [self.tableView.header beginRefreshing];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self reaquestMoreData];
    }];
}
-(void)requestData{
    _page=1;
    [self loadData];
}
-(void)reaquestMoreData{
    _page++;
    [self loadData];
}
#pragma mark-----请求数据
-(void)loadData{
    //拼路径
    NSString *path=[NSString stringWithFormat:TOPICSECOND_URL,self.whereId,self.page,self.whereId];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_page==1) {
            [self.dataSource removeAllObjects];
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *trailsArr=dic[@"trails"];
        for (NSDictionary *subDic in trailsArr) {
            DesDetailModel *model=[[DesDetailModel alloc]initWithDictionary:subDic error:nil];
            [self.dataSource addObject:model];
        }
        //结束下拉刷新
        if (_page==1) {
            [self.tableView.header endRefreshing];
        }
        //结束上拉加载
        else{
            [self.tableView.footer endRefreshing];
        }
        //刷新tableView
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark----tableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DesDetailTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"desDetail" forIndexPath:indexPath];
    DesDetailModel *model=self.dataSource[indexPath.row];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    cell.bigLabel.text=model.name;
    cell.littleLabel.text=model.destination;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //给cell添加一个动画
    [self addAnimationWithCell:cell];
    return cell;
}
#pragma mark---给cell添加一个动画--
-(void)addAnimationWithCell:(UITableViewCell *)cell{
    cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.8 animations:^{
        cell.layer.transform=CATransform3DMakeScale(1, 1, 1);
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
//点击某行调到下一界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThirdDestinationViewController *third=[[ThirdDestinationViewController alloc]init];
    DesDetailModel *model=self.dataSource[indexPath.row];
    third.imageUrl=model.cover;
    third.cityId=model.cityId;
    third.name=model.name;
    [self.navigationController pushViewController:third animated:YES];
}
#pragma mark---懒加载--
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
