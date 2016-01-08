//
//  ForthDestinationViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ForthDestinationViewController.h"
#import "ThirdTwoDesModel.h"
#import "ThirdTwoDesTableViewCell.h"
#import "ThirdTwoDesModel.h"
@interface ForthDestinationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation ForthDestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNav];
    self.navigationItem.title=@"讨论区";
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
    self.tableView.showsVerticalScrollIndicator=NO;
    //去掉多余的线
    self.tableView.tableFooterView=[[UIView alloc]init];

}
#pragma mark----tableView协议方法------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.talkArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuID=@"reusetwo id";
    ThirdTwoDesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuID];
    if (!cell) {
        cell=[[ThirdTwoDesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuID];
    }
    cell.model=self.talkArr[indexPath.row];
    //去掉点击的灰色效果
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuID=@"reusetwo id";
    ThirdTwoDesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuID];
    if (!cell) {
        cell=[[ThirdTwoDesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuID];
    }
    cell.model=self.talkArr[indexPath.row];
    return cell.maxY+10;
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
