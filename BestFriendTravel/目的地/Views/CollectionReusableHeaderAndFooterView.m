//
//  CollectionReusableHeaderAndFooterView.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "CollectionReusableHeaderAndFooterView.h"

@implementation CollectionReusableHeaderAndFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.showView=[[UIView alloc]init];
        [self customView];
    }
    return self;
}
-(void)customView{
    self.label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    _label.textColor=[UIColor lightGrayColor];
    _label.font=[UIFont boldSystemFontOfSize:18];
    [self.showView addSubview:_label];
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 12, 6, 18)];
    _imageView.layer.cornerRadius=3;
    _imageView.layer.masksToBounds=YES;
    [self.showView addSubview:_imageView];
    [self addSubview:self.showView];
}
@end
