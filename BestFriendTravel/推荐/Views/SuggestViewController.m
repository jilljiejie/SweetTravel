//
//  SuggestViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/24.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "SuggestViewController.h"
#import "HeaderViewController.h"
#import "HeaderScrollView.h"
#import "Common.h"
#import "CommonModel+NetRequest.h"
#import "CommonModel.h"
#import "SuggestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FindTableViewCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

#import "MoreFindViewController.h"//发现最美景致更多

#import "MoreOutViewController.h"//户外达人更多
#import "MoreQuestionViewController.h"//每日一问更多
#import "MoreHotViewController.h"//热门游记更多
#import "ShowDetailViewController.h"//展示详情
@interface SuggestViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataSource;//最外层数据
@property(nonatomic,strong)NSMutableArray *questionArr;//每日一问数组
@property(nonatomic,strong)NSMutableArray *findArr;//发现最美景致
@property(nonatomic,strong)NSMutableArray *outArr;//户外达人
@property(nonatomic,strong)NSMutableArray *hotArr;//热门游记
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,assign)int Sn;
@property(nonatomic,strong)UISearchController *searchController;//搜索框

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self requestData];
}
-(void)createTableView{
    //tableView相关
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:250/255.f green:245/255.f blue:231/255.f alpha:1];
    [_tableView registerNib:[UINib nibWithNibName:@"SuggestionTableViewCell" bundle:nil] forCellReuseIdentifier:@"suggest"];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    //去掉分割线
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //设置头视图
    HeaderScrollView *header=[[HeaderScrollView alloc]init];
    header.sendPicture=^(NSString *str){
        HeaderViewController * headerVc=[[HeaderViewController alloc]init];
        headerVc.url=str;
        headerVc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:headerVc animated:YES];
    };
    [header loadData];
    self.tableView.tableHeaderView=header;

}

-(void)requestData{
    //每日一问
    [CommonModel requestDataWithSn:0 withURL:QUESTION_URL complectionBlock:^(NSMutableArray *array, NSError *error) {
        if (error==nil) {
            //下拉刷新操作
            [self.questionArr removeAllObjects];
            [self.questionArr addObjectsFromArray:array];
            [self.dataSource addObject:self.questionArr];
            //发现最美景致
            [CommonModel requestDataWithSn:0 withURL:FIND_URL complectionBlock:^(NSMutableArray *array, NSError *error) {
                if (error==nil) {
                    //下拉刷新操作
                    [self.findArr removeAllObjects];
                    [self.findArr addObjectsFromArray:array];
                    [self.dataSource addObject:self.findArr];
                    //户外达人
                    [CommonModel requestDataWithSn:0 withURL:OUT_URL complectionBlock:^(NSMutableArray *array, NSError *error) {
                        if (error==nil) {
                            //下拉刷新操作
                            [self.outArr removeAllObjects];
                            [self.outArr addObjectsFromArray:array];
                            [self.dataSource addObject:self.outArr];
                
                            //热门游记
                            [CommonModel requestDataWithSn:0 withURL:HOT_URL complectionBlock:^(NSMutableArray *array, NSError *error) {
                                if (error==nil) {
                                        [self.hotArr removeAllObjects];
                                        [self.hotArr addObjectsFromArray:array];
                                        [self.dataSource addObject:self.hotArr];
                                    //结束下拉刷新
//                                    [self.tableView.header endRefreshing];
                                }
                                [self.tableView reloadData];

                            }];

                        }
                        [self.tableView reloadData];
                    }];
                }
                [self.tableView reloadData];
            }];

        }
        [self.tableView reloadData];
    }];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return 1;
    }
    if (section==1){
        return 1;
    }
    if (section==2) {
        return 4;
    }
    else{
        NSArray *arr=self.dataSource[section];

        return arr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==1) {
        FindTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"find"];
        if (!cell) {
            cell=[[FindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"find"];
            cell.sendUrl=^(NSString *string){
                ShowDetailViewController *detail=[[ShowDetailViewController alloc]init];
                detail.url=string;
                
                [self.navigationController pushViewController:detail animated:YES];
            };
        }
            return cell;
    }
    else{
        SuggestionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"suggest" forIndexPath:indexPath];
        CommonModel *model=self.dataSource[indexPath.section][indexPath.row];
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.face2]];
        cell.titleLabel.text=model.title;
        cell.shortTilteLabel.text=model.short_title;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    view.backgroundColor=[UIColor whiteColor];
    NSArray *sectionTitle=@[@"每日一问",@"发现最美景致",@"户外达人",@"热门游记"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, SCREEN_W-200, 20)];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [view addSubview:label];
    
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(SCREEN_W-50, 5, 50, 20);
    rightButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"更多" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightButton];

    switch (section) {
        case 0:{
            label.text=sectionTitle[0];
            rightButton.tag=100+section;
        }
            break;
        case 1:{
            label.text=sectionTitle[1];

            rightButton.tag=100+section;
        }
            break;
        case 2:
        {
            label.text=sectionTitle[2];
            rightButton.tag=100+section;

        }
            break;
        case 3:{
            label.text=sectionTitle[3];
            rightButton.tag=100+section;
        }
            break;
        default:
            break;
    }

    return view;
}
-(void)rightButtonAction:(UIButton *)button{
    NSInteger number=button.tag-100;
    switch (number) {
        case 0:
        {
            MoreQuestionViewController *moreQuestion=[[MoreQuestionViewController alloc]init];
            moreQuestion.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:moreQuestion animated:YES];
        }
            break;
        case 1:
        {
            MoreFindViewController *moreFind=[[MoreFindViewController alloc]init];
            moreFind.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:moreFind animated:YES];
        }
            break;
        case 2:
        {
            MoreOutViewController *moreOut=[[MoreOutViewController alloc]init];
            moreOut.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:moreOut animated:YES];
        }
            break;
        case 3:
        {
            MoreHotViewController *hot=[[MoreHotViewController alloc]init];
            hot.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:hot animated:YES];
        }
            break;
            
        default:
            break;
    }
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        float width=(SCREEN_W-30)/2;
        float height=width;
        return height*3+40;
    }
    else{
        return 160;
    }
}
//设置每组的头视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//若不设置它会默认给一个高度
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1;
//}
//点击某行的响应事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr=self.dataSource[indexPath.section];
    CommonModel *model=arr[indexPath.row];
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
-(NSMutableArray *)questionArr{
    if (!_questionArr) {
        _questionArr=[[NSMutableArray alloc]init];
    }
    return _questionArr;
}
-(NSMutableArray *)findArr{
    if (!_findArr) {
        _findArr=[[NSMutableArray alloc]init];
    }
    return _findArr;
}
-(NSMutableArray *)outArr{
    if (!_outArr) {
        _outArr=[[NSMutableArray alloc]init];
    }
    return _outArr;
}
-(NSMutableArray *)hotArr{
    if (!_hotArr) {
        _hotArr=[[NSMutableArray alloc]init];
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
