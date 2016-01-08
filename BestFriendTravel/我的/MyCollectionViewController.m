//
//  MyCollectionViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/2.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "FindCollectionManager.h"
#import "FindAllTableViewCell.h"
#import "FindMainModel.h"
#import "UIImageView+WebCache.h"
@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"我的收藏";
    [self createTableView];
    [self createNav];
}
#pragma mark---设置返回按钮----
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
#pragma mark----tableView相关------
-(void)createTableView{
    //获取数据库中的所有数据
    FindCollectionManager *manager=[FindCollectionManager sharedFindCollectionManager];
    [manager getAllModelsBlock:^(NSArray *modelArray) {
        [self.dataSource addObjectsFromArray:modelArray];
        
    }];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //设置代理
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"FindAllTableViewCell" bundle:nil] forCellReuseIdentifier:@"findCell"];

    //去掉分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
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
//某行能否被编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//返回某一行的编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //返回删除样式
    return UITableViewCellEditingStyleDelete;
}
//滑动删除，执行某行的操作回调
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        FindMainModel *model=self.dataSource[indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        
        //删除数据库中的
        FindCollectionManager *manager=[FindCollectionManager sharedFindCollectionManager];
        [manager deleteModelwithProductId:model.product_id];
        //刷新表格
        [self.tableView reloadData];
    }
}

#pragma mark---懒加载----
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
