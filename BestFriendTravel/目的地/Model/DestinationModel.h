//
//  DestinationModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/27.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface DestinationModel : JSONModel
@property(nonatomic,copy)NSString *icon;//图片
@property(nonatomic,copy)NSString *trail_count;//路线
@property(nonatomic,copy)NSString *name;//地点名字
@property(nonatomic,copy)NSString<Optional> *region;//分组名

@end
