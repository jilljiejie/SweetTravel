//
//  TopicModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface TopicModel : JSONModel
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *selectId;
@property(nonatomic,copy)NSString *name;
@end
