//
//  AboutWeViewController.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/3.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "AboutWeViewController.h"
#import "ZTypewriteEffectLabel.h"
@interface AboutWeViewController ()

@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.logoImageView.layer.cornerRadius=10;
    self.logoImageView.layer.masksToBounds=YES;
    ZTypewriteEffectLabel *label=[[ZTypewriteEffectLabel alloc]initWithFrame:CGRectMake(50, 300, self.view.bounds.size.width-100, 100)];
    label.textColor=[UIColor clearColor];
    label.text=@"闺蜜朋友一起游,寻找最美风景,发现更多趣事,想去哪里去哪里,与朋友驴友一起体验旅行之乐趣。";
    label.typewriteEffectColor=[UIColor grayColor];
    label.numberOfLines=0;
    [label startTypewrite];
    label.typewriteEffectBlock=^(){

    };
    
    [self.view addSubview:label];
    
    
}
- (IBAction)backButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
