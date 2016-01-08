//
//  UserManager.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@interface UserManager : NSObject
+(UserManager *)shareUserManager;
-(void)insetIntoModel:(UserModel *)model;
-(NSArray *)getAllModel;
////判断学生是否存在
//-(BOOL)isExistWithUserName:(NSString *)userName;
@end
