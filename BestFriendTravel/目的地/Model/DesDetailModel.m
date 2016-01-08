//
//  DesDetailModel.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "DesDetailModel.h"

@implementation DesDetailModel
-(void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues{

}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"cityId"}];
}
@end
