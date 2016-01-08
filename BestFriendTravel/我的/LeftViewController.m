//
//  LeftViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/2.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"

#import "CustomViewController.h"//二维码扫描
#import "ErWeiMaViewController.h"
#import "AboutWeViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UIView *darkView;
@property(nonatomic,assign)int index;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index=0;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"meBack.jpg"]];

    [self createTableView];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor clearColor];
    //    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID=@"reuse id";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.textLabel.text=self.dataSource[indexPath.row];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.imageView.image=[UIImage imageNamed:self.imageArray[indexPath.row]];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0://夜景模式
        {
            if (_index%2==0) {
                [_darkView removeFromSuperview];
            }
            else{
                UIApplication *app=[UIApplication sharedApplication];
                AppDelegate *delegate=app.delegate;
                _darkView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
                _darkView.backgroundColor=[UIColor blackColor];
                _darkView.userInteractionEnabled=NO;
                _darkView.alpha=0.3;
                [delegate.window addSubview:_darkView];
            }
            _index++;

        }
            break;
        case 1://关于我们
        {
            AboutWeViewController *about=[[AboutWeViewController alloc]init];
            [self presentViewController:about animated:YES completion:nil];
        }
            break;
        case 2://扫描二维码
        {
            CustomViewController *vc=[[CustomViewController alloc]initWithIsQRCode:NO Block:^(NSString *str, BOOL isFinish) {
            }];
            vc.view.backgroundColor=[UIColor whiteColor];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 3://我的二维码
        {
            ErWeiMaViewController *erVc=[[ErWeiMaViewController alloc]init];
            erVc.hidesBottomBarWhenPushed=YES;
            [self presentViewController:erVc animated:YES completion:^{
                
            }];
//            [self.navigationController pushViewController:erVc animated:YES];

        }
            break;
        default:
            break;
    }
}
#pragma mark---懒加载
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]initWithObjects:@"夜景模式",@"关于我们",@"扫描二维码",@"我的二维码", nil];
    }
    return _dataSource;
}
-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray=[[NSMutableArray alloc]initWithObjects:@"iconfont-yejing",@"iconfont-guanyu",@"iconfont-saomiaoerweima-2",@"iconfont-erweima", nil];
    }
    return _imageArray;
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
