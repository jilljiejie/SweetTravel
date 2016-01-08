//
//  TravelWriteModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface TravelWriteModel : JSONModel
@property(nonatomic,copy)NSString *cover;//大图
@property(nonatomic,copy)NSString *avatar;//小图
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *start_date;//时间
@property(nonatomic,copy)NSString *source_link;//下一界面

@end
