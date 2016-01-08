//
//  RegistViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "RegistViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface RegistViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    MPMoviePlayerViewController *_mp;
}
@property(nonatomic,strong)NSData *imageData;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rigistButton.layer.cornerRadius=10;
    self.rigistButton.layer.masksToBounds=YES;
    [self customNav];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"account_bg"]];
    self.view.backgroundColor=[UIColor colorWithRed:39/255.0 green:175/255.0 blue:193/255.0 alpha:1];
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"用户注册";
    //设置用户头像
    self.headerImageView.userInteractionEnabled=YES;
    [self.headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewAction)]];
}
#pragma mark----左侧返回按钮------
//设置左侧的返回按钮
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
#pragma mark---上传头像-------
//点击头像的响应事件
-(void)headerImageViewAction{
    UIImagePickerController *pickerVc=[[UIImagePickerController alloc]init];
    //设置来源为本地相册
    pickerVc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    //是否允许编辑,点击图片后是否放大展示这张图片
    pickerVc.allowsEditing=YES;
    //设置代理
    pickerVc.delegate=self;
    //UIImagePickerController 是视图控制器的子类，通过模态化的方式展示
    [self presentViewController:pickerVc animated:YES completion:nil];

}
#pragma mark----允许编辑状态是点击choose触发这个方法---
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取图片的名字
    NSURL *imageUrl=[info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultBlock=^(ALAsset *myasset){
        ALAssetRepresentation *representation=[myasset defaultRepresentation];
        NSString *filename=[representation filename];
        NSLog(@"filename:%@",filename);
    };
    ALAssetsLibrary *assetslibrary=[[ALAssetsLibrary alloc]init];
    [assetslibrary assetForURL:imageUrl resultBlock:resultBlock failureBlock:nil];
    
    //获取图片
    self.headerImageView.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _imageData = UIImagePNGRepresentation(self.headerImageView.image);
    [defaults setObject:_imageData forKey:self.userNameLabel.text];
    [defaults synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark-----注册按钮的响应方法------
- (IBAction)registButtonAction:(id)sender {
    NSString *userName=self.userNameLabel.text;
    NSString *passWord=self.passWordLabel.text;
    NSString *repeatPassWord=self.repeatPassWordLabel.text;
    if (userName.length==0 || passWord.length==0 || repeatPassWord.length==0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"关键内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    UserManager *manager=[UserManager shareUserManager];
    NSArray *arr=[manager getAllModel];
    for (UserModel *model in arr) {
        if ([model.userName isEqualToString:userName]) {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"该用户已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }

    }
    if (![passWord isEqualToString:repeatPassWord]) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"俩次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    UserModel *userModel=[[UserModel alloc]init];
    userModel.userName=userName;
    userModel.passWord=passWord;
    [manager insetIntoModel:userModel];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
