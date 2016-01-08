//
//  TopicsViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "TopicsViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "TopicTableViewCell.h"
#import "TopicModel.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "SecondTopicViewController.h"
@interface TopicsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createTableView];
    //[self loadData];
}
#pragma mark---tableView相关----
-(void)createTableView{
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:nil] forCellReuseIdentifier:@"topicCell"];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    //去掉分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //上拉加载和下拉刷新
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    //立即刷新
    [self.tableView.header beginRefreshing];

}

#pragma mark-----请求数据
-(void)loadData{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:TOPIC_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.dataSource removeAllObjects];

        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *typesArr=dic[@"types"];
        for (NSDictionary *subDic in typesArr) {
            TopicModel *model=[[TopicModel alloc]initWithDictionary:subDic error:nil];
            [self.dataSource addObject:model];
        }
        //结束下拉刷新
        [self.tableView.header endRefreshing];

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
    TopicTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];
    TopicModel *model=self.dataSource[indexPath.row];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
//点击某行调到下一界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SecondTopicViewController *second=[[SecondTopicViewController alloc]init];
    second.hidesBottomBarWhenPushed=YES;
    TopicModel *model=self.dataSource[indexPath.row];
    second.whereId=model.selectId;
    second.name=model.name;
    [self.navigationController pushViewController:second animated:YES];
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
