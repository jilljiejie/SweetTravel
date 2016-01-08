//
//  ThirdTwoDesModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface ThirdTwoDesModel : JSONModel
@property(nonatomic,copy)NSString *content;//文字描述
@property(nonatomic,copy)NSString *avatar;//头像
@property(nonatomic,copy)NSString *nickname;//昵称
@property(nonatomic,copy)NSString *fav_count;//👍数
@property(nonatomic,copy)NSString *trail_title;//昵称下地文字
@end
