//
//  FindTableViewCell.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "FindTableViewCell.h"
#import "Common.h"
#import "FindCollectionViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CommonModel+NetRequest.h"
#import "CommonModel.h"
#import "DestinationViewController.h"
@interface FindTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end
@implementation FindTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadData];
        [self customView];
    }
    return self;
}
-(void)loadData{
    [CommonModel requestDataWithSn:0 withURL:FIND_URL complectionBlock:^(NSMutableArray *array, NSError *error) {
        if (error==nil) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:array];
        }
        //刷新数据
        [self.collectionView reloadData];
    }];
}
-(void)customView{
    UICollectionViewFlowLayout *flowLayOut=[[UICollectionViewFlowLayout alloc]init];
    flowLayOut.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    float width=(SCREEN_W-40-10)/2;
    float height=width;
    flowLayOut.itemSize=CGSizeMake(width, height);
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_W-40, height*3+20) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor=[UIColor whiteColor];
    
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator=NO;
    [_collectionView registerNib:[UINib nibWithNibName:@"FindCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collection"];
    
    [self.contentView addSubview:_collectionView];
}
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
//    DestinationViewController *detail=[[DestinationViewController alloc]init];
    CommonModel *model=self.dataSource[indexPath.item];
    NSString *url=model.url;
    self.sendUrl(url);
}
#pragma mark---懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
