//
//  CollectionReusableHeaderAndFooterView.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
//这个视图做为自定义页眉页脚视图,需要继承于UICollectionReusableView 类
@interface CollectionReusableHeaderAndFooterView : UICollectionReusableView
//用来显示内容的视图
@property(nonatomic,retain)UIView *showView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIImageView *imageView;
@end
