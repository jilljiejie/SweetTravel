//
//  DestinationViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/24.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "DestinationViewController.h"
#import "YFTopTabBarController.h"
#import "RoutesViewController.h"
#import "TopicsViewController.h"
#import "AFNetworking.h"
#import "Common.h"
#import "DestinationModel.h"
#import "DetinationDetailViewController.h"
@interface DestinationViewController ()<UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating>
@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation DestinationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self configUI];
    [self loadData];
    [self creatNav];
}
//布局UI
-(void)configUI{
    RoutesViewController *routes=[[RoutesViewController alloc]init];
    routes.title=@"路线库";
    TopicsViewController *topics=[[TopicsViewController alloc]init];
    topics.title=@"专题";
    YFTopTabBarController *tab=[[YFTopTabBarController alloc]init];
    tab.viewControllers=@[routes,topics];
    [tab addToParentViewController:self];
    
}
-(void)creatNav{
    self.navigationItem.title=@"目的地";
    //设置右侧的搜索按钮
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 50, 40);
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[[UIImage imageNamed:@"icon_actionbar_search_44x44"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
#pragma mark----右侧搜索按钮的响应方法------
-(void)rightButtonAction{
//设置searchBar
    _searchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    _searchController.delegate=self;
    _searchController.searchBar.delegate=self;
    _searchController.searchResultsUpdater=self;
    _searchController.searchBar.placeholder=@"请输入搜索的目的地";
    //是否显示蒙版（NO隐藏）
    _searchController.dimsBackgroundDuringPresentation=NO;
    //搜索时不覆盖导航
    _searchController.hidesNavigationBarDuringPresentation=NO;

    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [view addSubview:self.searchController.searchBar];
    //自适应位置
    [_searchController.searchBar sizeToFit];
    self.navigationItem.titleView=_searchController.searchBar;
    self.navigationItem.rightBarButtonItem=nil;
    self.navigationItem.leftBarButtonItem=nil;
}
#pragma mark----searchController协议----
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{

}
//searchController将要消失时
-(void)willDismissSearchController:(UISearchController *)searchController{
    self.navigationItem.titleView=nil;
    [self creatNav];
}
#pragma mark----UISearchBarDelegate-----
//点击搜索按钮时触发这个方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchKey=searchBar.text;
    NSLog(@"%@",searchKey);
    for (DestinationModel *model in self.dataSource) {
        if ([model.name isEqualToString:searchKey]) {//数组中有这个城市，调到第二个页面显示搜索结果
            DetinationDetailViewController *detail=[[DetinationDetailViewController alloc]init];
            detail.name=searchKey;
            [self.navigationController pushViewController:detail animated:YES];
            return;
        }
    }
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"抱歉" message:@"您搜索的城市不在我们的城市范围内，我们会尽快完善的" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}
#pragma mark----请求数据----
//请求数据
-(void)loadData{
//    [self.hud show:YES];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:ROUTALL_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *RegionsArr=dic[@"regions"];
        for (NSDictionary *dict in RegionsArr) {
            NSArray *provinceArr=dict[@"province"];
            for (NSDictionary *provinceDic in provinceArr) {
                DestinationModel *model=[[DestinationModel alloc]initWithDictionary:provinceDic error:nil];
                [self.dataSource addObject:model];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

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
