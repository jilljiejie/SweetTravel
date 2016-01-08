//
//  UserModel.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *passWord;
@end
