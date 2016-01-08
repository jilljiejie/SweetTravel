//
//  MoreQuestionViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "MoreQuestionViewController.h"
#import "SuggestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonModel+NetRequest.h"
#import "CommonModel.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "Common.h"
#import "ShowDetailViewController.h"
@interface MoreQuestionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger Sn;
@property(nonatomic,strong)MBProgressHUD *hud;//等待提示
@property(nonatomic,assign)int i;
@end

@implementation MoreQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    self.navigationItem.title=@"每日一问";
    [self customNav];
}
#pragma mark---设置左侧按钮----
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
#pragma mark-----请求数据---------
//请求数据
-(void)loadData{
    [self.hud show:YES];
    [CommonModel requestDataWithSn:_Sn withURL:QUESTION_URL complectionBlock:^(NSMutableArray *array, NSError *error) {
        if (error==nil) {
            if (_Sn==0) {
                //下拉刷新操作
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:array];
            }
            else{
            [self.dataSource addObjectsFromArray:array];
            }
            if (_Sn==0) {//停止下拉刷新
                [self.tableView.header endRefreshing];
            }
            else{//停止上拉加载
            [self.tableView.footer endRefreshing];
            }
        }
        [self.hud hide:YES];
        [self.tableView reloadData];
        
    }];
}
-(void)createTableView{
    //tableView相关
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator=NO;
    //注册Cell
    [_tableView registerNib:[UINib nibWithNibName:@"SuggestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"suggest"];
    //去掉分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //上拉加载和下拉刷新
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    //立即刷新
    [self.tableView.header beginRefreshing];
    
    _i=0;
    if (_i==0) {
        self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMoreData];
        }];
        _i++;
    }
}
-(void)requestData{
    _Sn=0;
    [self loadData];
}
-(void)requestMoreData{
    _Sn+=10;
    [self loadData];
}

#pragma mark----TableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SuggestionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"suggest" forIndexPath:indexPath];
    CommonModel *model=self.dataSource[indexPath.row];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.face2]];
    cell.titleLabel.text=model.title;
    cell.shortTilteLabel.text=model.short_title;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
//点击某行的响应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonModel *model=self.dataSource[indexPath.row];
    ShowDetailViewController *detail=[[ShowDetailViewController alloc]init];
    detail.url=model.url;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark---懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
//等待提示
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
