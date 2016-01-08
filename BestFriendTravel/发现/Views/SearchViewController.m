//
//  SearchViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/27.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "SearchViewController.h"
#import "Common.h"
@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *hotArr;
@property(nonatomic,strong)UISearchController *searchController;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self customNav];
}
//设置导航栏左边的返回按钮
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
-(void)createTableView{
    self.view.backgroundColor=[UIColor colorWithRed:250/255.f green:245/255.f blue:231/255.f alpha:1];
    self.navigationItem.title=@"选择城市";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_W, SCREEN_H-30) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //设置分割线的颜色
    _tableView.separatorColor=[UIColor whiteColor];
    //去掉多余的线
    _tableView.tableFooterView=[[UIView alloc]init];
    [self createTableHeaderView];
    
    [self.view addSubview:_tableView];

    self.tableView.backgroundColor=[UIColor clearColor];

    //搜索相关
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.frame=CGRectMake(0, 0, SCREEN_W, 30);
    
    [self.view addSubview:self.searchController.searchBar];
    
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder=@"请输入您要搜索的城市的名字";
    self.searchController.searchBar.delegate=self;
    self.searchController.delegate=self;
    //修改return按钮的样式
    self.searchController.searchBar.returnKeyType=UIReturnKeySearch;
    //设置searchBar颜色
    self.searchController.searchBar.barTintColor=[UIColor colorWithRed:250/255.f green:245/255.f blue:231/255.f alpha:1];
    //搜索时不覆盖导航栏
    self.searchController.hidesNavigationBarDuringPresentation=NO;
    
}
//设置头视图
-(void)createTableHeaderView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 60)];
    view.backgroundColor=[UIColor colorWithRed:250/255.f green:245/255.f blue:231/255.f alpha:1];

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W-15, 30)];
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textColor=[UIColor grayColor];
    [view addSubview:label];
    label.text=@"热门城市";
    for (int i=0; i<4; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        float width=(SCREEN_W-150)/4;
        button.frame=CGRectMake(30+i*(width+30), 30, width, 30);
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.cornerRadius=15;
        button.layer.masksToBounds=YES;
        button.layer.borderColor=[UIColor whiteColor].CGColor;
        button.layer.borderWidth=1;
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.tag=100+i;
        [button setTitle:self.hotArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor clearColor];
        [view addSubview:button];
    }
    self.tableView.tableHeaderView=view;
}
//头视图button的点击事件
-(void)buttonClick:(UIButton *)button{
    NSString *str=button.titleLabel.text;
    self.backStringBlock(str);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---点击搜索按钮时触发的方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchKey=searchBar.text;
    BOOL isActive=[self.searchController isActive];
    if (isActive==YES) {
        self.searchController.active=NO;
    }
    for (NSString *str in self.dataSource) {
        if ([str isEqualToString:searchKey]) {
            //返回上个界面显示搜索结果
            [self.navigationController popViewControllerAnimated:YES];
            self.backStringBlock(str);
            return;
        }
    }
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"亲，您搜索的城市不在我们的范围内哦" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alertView show];
}


#pragma mark---tableView协议方法--
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuseID=@"reuse id";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.textLabel.text=self.dataSource[indexPath.row];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        cell.textLabel.textColor=[UIColor grayColor];
    }
        cell.backgroundColor=[UIColor clearColor];

    return cell;

}
//设置分组标题
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W-10, 30)];
    label.font=[UIFont boldSystemFontOfSize:16];
    label.textColor=[UIColor grayColor];
    [view addSubview:label];
    label.text=@"全部城市";

    return view;
}
//设置分组的头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//点击某行的响应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str=self.dataSource[indexPath.row];
    self.backStringBlock(str);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---懒加载--
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]initWithObjects:@"阿布扎比",@"澳大利亚",@"巴黎",@"包头",@"北京",@"长沙",@"成都",@"重庆",@"大理",@"东京",@"广州",@"贵阳",@"哈尔滨",@"杭州",@"赫尔辛基",@"京都",@"昆明",@"伦敦",@"没过",@"明尼阿波利斯",@"青岛",@"清迈",@"日本",@"厦门",@"上海",@"深圳",@"台北", @"泰国",@"武汉",@"乌鲁木齐",@"无锡",@"香港",@"悉尼",@"淄博",nil];
    }
    return _dataSource;
}

-(NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr=[[NSMutableArray alloc]initWithObjects:@"北京",@"上海",@"深圳",@"广州", nil];
    }
    return _hotArr;
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
