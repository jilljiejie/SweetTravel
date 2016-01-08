//
//  HeaderScrollView.m
//  11.3作业
//
//  Created by qianfeng on 15/11/3.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "HeaderScrollView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "headerModel.h"
#import "Common.h"
#import "AppDelegate.h"
#define  URL_HEAD @"http://api.breadtrip.com/v2/index/?lat=%25s40.113636410144636&lng=%25s116.2515586441803"
@interface HeaderScrollView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)NSTimer *timer;

@end
@implementation HeaderScrollView
//重写初始化
-(id)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.frame=CGRectMake(0, 0, SCREEN_W, 200);
    }
    return self;
}

-(void)creatScroll{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
    
    float width=self.scrollView.frame.size.width;
    float height=self.scrollView.frame.size.height;
    //循环滚动时头和为要加俩张图片
    for (int i=0; i<_dataSource.count+2; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
//        //设置图片还没加载出来时的占位图片
        imageView.image=[UIImage imageNamed:@"zhanwei.jpg"];
        //给imageView添加手势
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)]];
        imageView.tag=1000+i;
        
        headerModel *model=[[headerModel alloc]init];
        if (i==0) {
            model=_dataSource.lastObject;
        }
        else if (i==_dataSource.count+1){
            model=_dataSource.firstObject;
        }
        else{
            model=_dataSource[i-1];
        }
        
        imageView.userInteractionEnabled=YES;
        //获取图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.Pic]];
        [_scrollView addSubview:imageView];
    }
    //设置滚动视图的滚动范围
    _scrollView.contentSize=CGSizeMake((_dataSource.count+2)*width, height);
    //设置默认显示的图片
    _scrollView.contentOffset=CGPointMake(self.scrollView.frame.size.width, 0);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.bounces=NO;
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    
    [self addSubview:_scrollView];
    //设置底部的UIView
    UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 170, SCREEN_W, 30)];
    bottomView.backgroundColor=[UIColor clearColor];
    //bottomView.alpha=0.8;
    [self addSubview:bottomView];
    
    //pageControl相关
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_W/2-50, 0, 100, 30)];
    _pageControl.numberOfPages=_dataSource.count;
    _pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    _pageControl.pageIndicatorTintColor=[UIColor grayColor];
    [bottomView addSubview:_pageControl];
    //启动计时器
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:4]];
}
//imageView的点击事件
-(void)imageViewClick:(UITapGestureRecognizer *)tap{
    UIImageView *imageView=(UIImageView *)tap.view;
    long i=imageView.tag-1000;
    if (i==0) {
        i=_dataSource.count-1;
    }
    if (i==_dataSource.count+1) {
        i=0;
    }
    else{
        i=i-1;
    }
    headerModel *model=_dataSource[i];
    NSString *url=model.Url;
    self.sendPicture(url);
}

//请求数据
-(void)loadData{
    _dataSource=[[NSMutableArray alloc]init];
    //获取manager
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:URL_HEAD parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic=dic[@"data"];
        NSArray *eleArr=dataDic[@"elements"];
        
        NSDictionary *Value0 = eleArr[0];
        NSArray *dataArray = Value0[@"data"];
        NSArray *firstData  =  dataArray[0];
        for (NSDictionary *dict  in firstData) {
            headerModel *model=[[headerModel alloc]init];
            model.Pic=dict[@"image_url"];
            model.Url=dict[@"html_url"];
            [self.dataSource addObject:model];
        }
        [self creatScroll];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//懒加载
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}
//实现协议方法
//减速完成（停止）----（手动滑动时调用）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page=scrollView.contentOffset.x/SCREEN_W;
    headerModel *model=[[headerModel alloc]init];
    CGFloat width=self.scrollView.frame.size.width;
    if (page==0) {
        scrollView.contentOffset=CGPointMake(self.dataSource.count*width, 0);
        self.pageControl.currentPage=self.dataSource.count;
        model=_dataSource[self.dataSource.count-1];
    }
    else if (page==self.dataSource.count+1){
        scrollView.contentOffset=CGPointMake(width, 0);
        self.pageControl.currentPage=0;
        model=_dataSource.firstObject;
    }
    else{
        self.pageControl.currentPage=page-1;
        model=_dataSource[page-1];
    }
    
}
/** setContnetOffSet: animated:YES , 动画完成之后, 不会走减速的方法, 而是走这个方法 */
//自动滑动时调用
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int page=scrollView.contentOffset.x/SCREEN_W;
    headerModel *model=[[headerModel alloc]init];
    CGFloat width=self.scrollView.frame.size.width;
    if (page==0) {
        scrollView.contentOffset=CGPointMake(self.dataSource.count*width, 0);
        self.pageControl.currentPage=self.dataSource.count;
        model=_dataSource[self.dataSource.count];
    }
    else if (page==self.dataSource.count+1){
        scrollView.contentOffset=CGPointMake(width, 0);
        self.pageControl.currentPage=0;
        model=_dataSource.firstObject;
    }
    else{
        self.pageControl.currentPage=page-1;
        model=_dataSource[page-1];
    }
}
//计时器的响应事件
/** setContnetOffSet: animated:YES , 动画完成之后, 不会走减速的方法, 而是走这个方法 */
-(void)timerAction{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+SCREEN_W, 0) animated:YES];

}






@end
