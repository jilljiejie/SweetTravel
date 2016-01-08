//
//  LoginViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
#import "UserManager.h"
#import "UMSocial.h"
@interface LoginViewController ()
@property(nonatomic,strong)UIImage *image;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图片
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"account_bg"]];
    self.view.backgroundColor=[UIColor colorWithRed:39/255.0 green:175/255.0 blue:193/255.0 alpha:1];
    self.loginButton.layer.cornerRadius=10;
    self.loginButton.layer.masksToBounds=YES;
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"登录";
    [self customNav];
}
//设置左侧的返回按钮
-(void)customNav{
    UIImageView *leftImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftImage.image=[UIImage imageNamed:@"icon_back_button"];
    leftImage.userInteractionEnabled=YES;
    [leftImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftAction)]];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftImage];
}
//返回
-(void)leftAction{
    self.backImageBlock(_image);
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark---登录按钮的响应方法-----
- (IBAction)loginButtonAction:(UIButton *)sender {
    NSString *userName=self.userNameLabel.text;
    NSString *passWord=self.passWordLabel.text;
    if (userName.length==0 || passWord.length==0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"关键内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    UserManager *manager=[UserManager shareUserManager];
    NSArray *arr=[manager getAllModel];
    NSLog(@"***%@",arr);
    for (UserModel *model1 in arr) {
        if ([model1.userName isEqualToString:userName] && [model1.passWord isEqualToString:passWord]) {//登录成功
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"登录成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSData *imageData=[defaults objectForKey:self.userNameLabel.text];
            _image=[UIImage imageWithData:imageData];
            
            return;
        }
    }
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"错误,请检查您所填写的信息是否正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];//退出编辑样式
}
#pragma mark---第三方登录-----
- (IBAction)sinaLogin:(id)sender {
    //新浪登录
    //指定平台名称
    UMSocialSnsPlatform * platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    platform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity * response)
                               {
                                   //回调结果
                                   if (response.responseCode == UMSResponseCodeSuccess)
                                   {
                                       //拿到用户信息
                                       UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                                       NSLog(@"%@~~~%@~~~%@~~~%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                                   }
                               });
}
- (IBAction)wechatLogin:(id)sender {
    //微信登录
    //指定平台名称
    UMSocialSnsPlatform * platform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    platform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity * response)
                               {
                                   //回调结果
                                   if (response.responseCode == UMSResponseCodeSuccess)
                                   {
                                       //拿到用户信息
                                       UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatSession];
                                       NSLog(@"%@~~~%@~~~%@~~~%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
                                   }
                               });
    
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
