//
//  TravelWriteViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "TravelWriteViewController.h"
#import "Common.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "TravelWriteModel.h"
#import "TravelWriteTableViewCell.h"
#import "ShowDetailViewController.h"

@interface TravelWriteViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation TravelWriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
    [self createNav];//设计导航条
    self.navigationItem.title=@"相关游记";
}
//设计返回按钮
-(void)createNav{
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftImage.image=[UIImage imageNamed:@"icon_back_button"];
    leftImage.userInteractionEnabled=YES;
    [leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftImage];
}
//返回上一页
-(void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---tableView相关-----
-(void)createTableView{
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"TravelWriteTableViewCell" bundle:nil] forCellReuseIdentifier:@"travelCell"];
    //去掉多余的线
    self.tableView.tableFooterView=[[UIView alloc]init];
}
//请求数据
-(void)loadData{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString *path=[NSString stringWithFormat:TRAVELWRITE_URL,self.cityId,self.cityId];
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *logsArr=dic[@"logs"];
        for (NSDictionary *logsDic in logsArr) {
            TravelWriteModel *model=[[TravelWriteModel alloc]init];
            model.cover=logsDic[@"cover"];
            model.start_date=logsDic[@"start_date"];
            model.source_link=logsDic[@"source_link"];
            NSDictionary *createdByDic=logsDic[@"created_by"];
            model.avatar=createdByDic[@"avatar"];
            model.nickname=createdByDic[@"nickname"];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark----tableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TravelWriteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"travelCell" forIndexPath:indexPath];
    TravelWriteModel *model=self.dataSource[indexPath.row];
    [cell.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    [cell.littleImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    cell.dateAndNameLabel.text=[NSString stringWithFormat:@"%@  by %@",model.start_date,model.nickname];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
//点击某行调到下一界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowDetailViewController *detail=[[ShowDetailViewController alloc]init];
    TravelWriteModel *model=self.dataSource[indexPath.row];
    detail.url=model.source_link;
    [self.navigationController pushViewController:detail animated:YES];
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
