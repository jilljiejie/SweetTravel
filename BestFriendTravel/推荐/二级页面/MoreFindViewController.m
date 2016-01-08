//
//  MoreFindViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "MoreFindViewController.h"
#import "SuggestionTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonModel+NetRequest.h"
#import "CommonModel.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "Common.h"
#import "ShowDetailViewController.h"
#import "FindCollectionViewCell.h"
@interface MoreFindViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)MBProgressHUD *hud;//等待提示
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation MoreFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNav];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"发现最美景致";
    [self configUI];
    [self loadData];
    
    
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
#pragma mark---布局collectionView----------
-(void)configUI{
    float width=(SCREEN_W-40-20)/2;
    float height=width;
    UICollectionViewFlowLayout *flowLayOut=[[UICollectionViewFlowLayout alloc]init];
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(20, 10, SCREEN_W-40, SCREEN_H-10) collectionViewLayout:flowLayOut];
    flowLayOut.itemSize=CGSizeMake(width, height);
    //设置滚动方向
    flowLayOut.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collectionView.backgroundColor=[UIColor whiteColor];
    //隐藏垂直方向滚动条
    _collectionView.showsVerticalScrollIndicator=NO;
    _collectionView.delegate=self;
    _collectionView.dataSource=self;

    [_collectionView registerNib:[UINib nibWithNibName:@"FindCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collection"];
    [self.view addSubview:_collectionView];

}
//请求数据
-(void)loadData{
    [self.hud show:YES];
    [CommonModel requestDataWithSn:0 withURL:FIND_URL complectionBlock:^(NSMutableArray *array, NSError *error) {
        if (error==nil) {
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:array];
        }
        [self.hud hide:YES];
        [self.collectionView reloadData];
        
    }];
}

#pragma mark----collectionView协议方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FindCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    CommonModel *model=self.dataSource[indexPath.item];
    [cell.bgColImageView sd_setImageWithURL:[NSURL URLWithString:model.face2]];
    cell.titleClLabel.text=model.title;
    cell.shortTitleClLabel.text=model.short_title;
    return cell;
}
//点击某个的响应方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CommonModel *model=self.dataSource[indexPath.item];
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
