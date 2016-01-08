//
//  CommonModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface CommonModel : JSONModel
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *short_title;
@property(nonatomic,copy)NSString *face2;
@property(nonatomic,copy)NSString *url;
@end
