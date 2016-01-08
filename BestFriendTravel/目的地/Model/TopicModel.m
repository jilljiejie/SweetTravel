//
//  TopicModel.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"selectId"}];
}
@end
