//
//  YFTopTabBarController.m
//  TopTabBar
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 张玉飞. All rights reserved.
//

#import "YFTopTabBarController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define TOP_BAR_HEIGHT 30
@interface YFTopTabBarController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UISegmentedControl * segment;
}
@property (nonatomic,assign) NSInteger currentIndex;
@end

@implementation YFTopTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currentIndex=0;
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    segment.selectedSegmentIndex=_currentIndex;
}
-(UIView *)topTabBar{
    if (!_topTabBar) {
        _topTabBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_BAR_HEIGHT)];
        _topTabBar.backgroundColor=[UIColor whiteColor];
        _topTabBar.alpha=0.5;
        [self.view addSubview:_topTabBar];
    }
    return _topTabBar;
}
-(void)setViewControllers:(NSArray *)viewControllers{
    if (viewControllers.count>0) {
        _viewControllers=viewControllers;
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topTabBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.topTabBar.frame))];
        scrollView.delegate=self;
        scrollView.bounces=NO;
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.pagingEnabled=YES;
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*_viewControllers.count, scrollView.bounds.size.height);
        [self.view addSubview:scrollView];
        NSMutableArray *marr=[NSMutableArray array];
        for (int i=0; i<_viewControllers.count; i++) {
            UIViewController *vc=_viewControllers[i];
            [marr addObject:vc.title];
            vc.view.frame=CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView.bounds.size.height);
            [scrollView addSubview:vc.view];
            [self addChildViewController:vc];
        }
        segment = [[UISegmentedControl alloc]initWithItems:marr];
        segment.frame = CGRectMake(10, 3, SCREEN_WIDTH-20, TOP_BAR_HEIGHT-6);
        segment.tintColor = [UIColor lightGrayColor];
        [segment addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventValueChanged];
        segment.selectedSegmentIndex = 0;
        [_topTabBar addSubview:segment];
    }
}
-(void)addToParentViewController:(UIViewController *)viewController{
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}
-(void)changeViewController:(UISegmentedControl *)sender{
    self.currentIndex=sender.selectedSegmentIndex;
    scrollView.contentOffset=CGPointMake(_currentIndex*SCREEN_WIDTH, 0);
}
-(void)scrollViewDidScroll:(UIScrollView *)sender{
    self.currentIndex=floor((sender.contentOffset.x-SCREEN_WIDTH/2)/SCREEN_WIDTH)+1;
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
