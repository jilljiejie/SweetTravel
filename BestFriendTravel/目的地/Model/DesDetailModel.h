//
//  DesDetailModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface DesDetailModel : JSONModel
@property(nonatomic,copy)NSString *cover;//图片的名字
@property(nonatomic,copy)NSString *destination;//地点名
@property(nonatomic,copy)NSString *name;//
@property(nonatomic,copy)NSString *cityId;//城市的id（下个页面的参数）
@end
