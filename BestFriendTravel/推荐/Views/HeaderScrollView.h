//
//  HeaderScrollView.h
//  11.3作业
//
//  Created by qianfeng on 15/11/3.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderScrollView : UIView
//请求数据
-(void)loadData;
@property(nonatomic,copy)void(^sendPicture)(NSString *);



@end
