//
//  RoutesViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "RoutesViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "DestinationModel.h"
#import "DestinationCollectionCell.h"//自定义的CollectionCell
#import "CollectionReusableHeaderAndFooterView.h"
#import "DetinationDetailViewController.h"//详情界面
#import "MBProgressHUD.h"
@interface RoutesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *HDArr;//华东
@property(nonatomic,strong)NSMutableArray *HBArr;//华北
@property(nonatomic,strong)NSMutableArray *XNArr;//西南
@property(nonatomic,strong)NSMutableArray *XBArr;//西北
@property(nonatomic,strong)NSMutableArray *HNArr;//华南
@property(nonatomic,strong)NSMutableArray *HZArr;//华中
@property(nonatomic,strong)NSMutableArray *DBArr;//东北
@property(nonatomic,strong)NSMutableArray *GATArr;//港澳台
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation RoutesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self creatCollectionView];
    
    [self loadData];
}
-(void)creatCollectionView{
    //CollectionView继承于ScrollView,所以,当加到导航控制器上时,需要去避开导航条的遮挡
    //    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    //创建一个格式布局对象,用来去控制格式化collectionView的显示格式
    UICollectionViewFlowLayout *flowOut=[[UICollectionViewFlowLayout alloc]init];
    //设置当前collectionView 的滚动方向
    flowOut.scrollDirection=UICollectionViewScrollDirectionVertical;
    float width=(SCREEN_W-40)/3;
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    //item项的大小
    flowOut.itemSize=CGSizeMake(width, width+40);
    //设置页眉页脚的大小
    flowOut.headerReferenceSize = CGSizeMake(SCREEN_W, 40);
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W-20, SCREEN_H) collectionViewLayout:flowOut];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    //设置代理
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"DestinationCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"destionationCell"];
    //页眉页脚也需要去注册使用
    [_collectionView registerClass:[CollectionReusableHeaderAndFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView];
    
}
#pragma mark----请求数据----
//请求数据
-(void)loadData{
    [self.hud show:YES];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:ROUTALL_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *RegionsArr=dic[@"regions"];
        //华东
        NSDictionary *dd=RegionsArr.firstObject;
        NSArray *provinceArray=dd[@"province"];
        for (NSDictionary *subDic in provinceArray) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd[@"region"];
            [self.HDArr addObject:model];
        }
        [self.dataSource addObject:self.HDArr];
        //华北
        NSDictionary *dd1=RegionsArr[1];
        NSArray *provinceArray1=dd1[@"province"];
        for (NSDictionary *subDic in provinceArray1) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd1[@"region"];
            [self.HBArr addObject:model];
        }
        [self.dataSource addObject:self.HBArr];
        //西南
        NSDictionary *dd2=RegionsArr[2];
        NSArray *provinceArr2=dd2[@"province"];
        for (NSDictionary *subDic in provinceArr2) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd2[@"region"];
            [self.XNArr addObject:model];
        }
        [self.dataSource addObject:self.XNArr];
        //西北
        NSDictionary *dd3=RegionsArr[3];
        NSArray *provinceArr3=dd3[@"province"];
        for (NSDictionary *subDic in provinceArr3) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd3[@"region"];
            [self.XBArr addObject:model];
        }
        [self.dataSource addObject:self.XBArr];
        //华南
        NSDictionary *dd4=RegionsArr[4];
        NSArray *provinceArr4=dd4[@"province"];
        for (NSDictionary *subDic in provinceArr4) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd4[@"region"];
            [self.HNArr addObject:model];
        }
        [self.dataSource addObject:self.HNArr];
        //华中
        NSDictionary *dd5=RegionsArr[5];
        NSArray *provinceArr5=dd5[@"province"];
        for (NSDictionary *subDic in provinceArr5) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd5[@"region"];
            [self.HZArr addObject:model];
        }
        [self.dataSource addObject:self.HZArr];
        //东北
        NSDictionary *dd6=RegionsArr[6];
        NSArray *provinceArr6=dd6[@"province"];
        for (NSDictionary *subDic in provinceArr6) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd6[@"region"];
            [self.DBArr addObject:model];
        }
        [self.dataSource addObject:self.DBArr];
        //港澳台
        NSDictionary *dd7=RegionsArr[7];
        NSArray *provinceArr7=dd7[@"province"];
        for (NSDictionary *subDic in provinceArr7) {
            DestinationModel *model=[[DestinationModel alloc]initWithDictionary:subDic error:nil];
            model.region=dd7[@"region"];
            [self.GATArr addObject:model];
        }
        [self.dataSource addObject:self.GATArr];
        //刷新
        [self.collectionView reloadData];
        [self.hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark----collectionView协议方法
//分组数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}
//每组显示的item数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr=self.dataSource[section];
    return arr.count;
}
//item的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DestinationCollectionCell *item=[collectionView dequeueReusableCellWithReuseIdentifier:@"destionationCell" forIndexPath:indexPath];
    DestinationModel *model=self.dataSource[indexPath.section][indexPath.item];
    [item.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    item.routeLabel.text=[NSString stringWithFormat:@"路线%@",model.trail_count];
    return item;
}
//点击某个item的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetinationDetailViewController *detail=[[DetinationDetailViewController alloc]init];
    NSArray *arr=self.dataSource[indexPath.section];
    DestinationModel *model=arr[indexPath.row];
    detail.name=model.name;
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
}
//设置页眉页脚的内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionReusableHeaderAndFooterView *myView=nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        myView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        myView.showView.frame=CGRectMake(0, 0, SCREEN_W, 40);
        NSArray *arr=self.dataSource[indexPath.section];
        DestinationModel *model=arr[indexPath.row];
        myView.label.text=model.region;
        myView.imageView.image=[UIImage imageNamed:@"account_bg"];
    }
    return myView;
}
#pragma mark---懒加载----
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)HDArr{
    if (!_HDArr) {
        _HDArr=[[NSMutableArray alloc]init];
    }
    return _HDArr;
}
-(NSMutableArray *)HBArr{
    if (!_HBArr) {
        _HBArr=[[NSMutableArray alloc]init];
    }
    return _HBArr;
}
-(NSMutableArray *)XNArr{
    if (!_XNArr) {
        _XNArr=[[NSMutableArray alloc]init];
    }
    return _XNArr;
}
-(NSMutableArray *)XBArr{
    if (!_XBArr) {
        _XBArr=[[NSMutableArray alloc]init];
    }
    return _XBArr;
}
-(NSMutableArray *)HNArr{
    if (!_HNArr) {
        _HNArr=[[NSMutableArray alloc]init];
    }
    return _HNArr;
}
-(NSMutableArray *)HZArr{
    if (!_HZArr) {
        _HZArr=[[NSMutableArray alloc]init];
    }
    return _HZArr;
}
-(NSMutableArray *)DBArr{
    if (!_DBArr) {
        _DBArr=[[NSMutableArray alloc]init];
    }
    return _DBArr;
}
-(NSMutableArray *)GATArr{
    if (!_GATArr) {
        _GATArr=[[NSMutableArray alloc]init];
    }
    return _GATArr;
}
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
