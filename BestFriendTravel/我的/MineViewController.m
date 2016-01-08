//
//  MineViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/24.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "MineViewController.h"
#import "Common.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import <MediaPlayer/MediaPlayer.h>//上传头像用
#import "MyCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+MMDrawerController.h"//侧滑
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    MPMoviePlayerViewController *_mp;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIImageView *imageView;//用来放头像的照片

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    

}
#pragma mark----布局UI
-(void)configUI{
//    self.navigationController.navigationBarHidden=YES;
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    //设置头视图
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 300)];
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    _imageView.layer.cornerRadius=45;
    _imageView.layer.masksToBounds=YES;
    _imageView.layer.borderColor=[UIColor whiteColor].CGColor;
    _imageView.layer.borderWidth=2;
    _imageView.center=view.center;
    _imageView.userInteractionEnabled=YES;
    _imageView.backgroundColor=[UIColor whiteColor];
    view.backgroundColor=[UIColor colorWithRed:39/255.f green:175/255.f blue:193/255.f alpha:1];
    _imageView.image=[UIImage imageNamed:@"shangchuantouxiang1.jpg"];
    [view addSubview:_imageView];
    NSArray *titleArr=@[@"登录",@"注册"];
    for (int i=0; i<2; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        float width=(SCREEN_W-200)/3;//距离左边的距离
        button.frame=CGRectMake(width+(100+width)*i, CGRectGetMaxY(_imageView.frame)+10, 100, 30);
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius=10;
        button.layer.masksToBounds=YES;
        button.layer.borderColor=[UIColor whiteColor].CGColor;
        button.layer.borderWidth=2;
        button.tag=100+i;
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    self.tableView.tableHeaderView=view;
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 10, 30, 30);
    [button setImage:[UIImage imageNamed:@"shezhi"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)setButtonAction{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];

}


#pragma mark---登录注册按钮的响应方法-----
-(void)buttonAction:(UIButton *)button{
    NSInteger num=button.tag-100;
    if (num==0) {//调到登录界面
        LoginViewController *login=[[LoginViewController alloc]init];
        login.backImageBlock=^(UIImage *image){
            self.imageView.image=image;
        };

        [self.navigationController pushViewController:login animated:YES];
    }
    else{//调到注册界面
        RegistViewController *regist=[[RegistViewController alloc]init];
        [self.navigationController pushViewController:regist animated:YES];
    }
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
        cell.textLabel.textColor=[UIColor grayColor];
        cell.textLabel.font=[UIFont systemFontOfSize:15];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {//清除缓存
        [self folerSizeWithPath:[self getPath]];
    }
    if (indexPath.row==0) {//我的收藏
        MyCollectionViewController *myCollection=[[MyCollectionViewController alloc]init];
//        myCollection.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:myCollection animated:YES];
    }
    if (indexPath.row==2) {
        //清除图片缓存
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清除图片缓存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
        alertView.tag=300;
        [alertView show];
    }
    
}

#pragma mark---获取缓存文件路径
-(NSString *)getPath{
    NSString *path=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    return path;
}
#pragma mark---计算缓存文件的大小
-(CGFloat)folerSizeWithPath:(NSString *)path
{
    //初始化文件管理类
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize=0.0;
    if ([fileManager fileExistsAtPath:path]) {
        //如果存在
        //计算文件的大小
        //获取目录下所有的子文件
        NSArray *fileArray=[fileManager subpathsAtPath:path];
        for (NSString *fileName in fileArray) {
            //获取每个文件的路径
            NSString *filePath=[path stringByAppendingPathComponent:fileName];
            //计算每个子文件的大小
            long fileSize=[fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
            folderSize=folderSize+fileSize/1024.0/1024.0;
        }
        //删除文件
        [self deleteFileSize:folderSize];
        return folderSize;
    }
    return 0;
}
-(void)deleteFileSize:(CGFloat)folderSize{
    if (folderSize>0.01) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"缓存大小:%.2fM,是否清除",folderSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=400;
        [alertView show];
    }
    else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存已全部清理" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==400) {
        if (buttonIndex==1) {//点击了确定
            //彻底删除文件
            [self clearCachWith:[self getPath]];
        }
        return;
    }
    if (alertView.tag==300) {
        if (buttonIndex==0) {
            //清除图片缓存
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
        }
        return;
    }

}
//清除文件
-(void)clearCachWith:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *fileArray=[fileManager subpathsAtPath:path];
        for (NSString *fileName in fileArray) {
            //获取子文件的路径
            NSString *filePath=[path stringByAppendingPathComponent:fileName];
            //移除指定路径下地文件
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
}
#pragma mark---懒加载---
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]initWithObjects:@"我的收藏",@"清除缓存",@"清除图片缓存", nil];
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
