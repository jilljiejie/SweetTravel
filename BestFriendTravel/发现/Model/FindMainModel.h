//
//  FindMainModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface FindMainModel : JSONModel
@property(nonatomic,copy)NSString<Optional> *title;//描述
@property(nonatomic,copy)NSString<Optional> *title_page;//大图的网址
@property(nonatomic,copy)NSString<Optional> *avatar_l;//小图的网址
@property(nonatomic,copy)NSString<Optional> *date_str;//时间
@property(nonatomic,copy)NSString<Optional> *address;//地点
@property(nonatomic,copy)NSString<Optional> *like_conut;//喜欢人数
@property(nonatomic,copy)NSString<Optional> *price;//价钱
@property(nonatomic,copy)NSString<Optional> *name;
@property(nonatomic,copy)NSString<Optional> *tab_list;//类型
@property(nonatomic,copy)NSString<Optional> *findId;
@property(nonatomic,copy)NSString<Optional> *product_id;//下个界面的参数
@end
