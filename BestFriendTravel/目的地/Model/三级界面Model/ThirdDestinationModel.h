//
//  ThirdDestinationModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface ThirdDestinationModel : JSONModel
@property(nonatomic,copy)NSString *destination;//地点
@property(nonatomic,copy)NSString *detail;//景点描述
@property(nonatomic,copy)NSString *name;//景点名称


@end
