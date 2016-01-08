//
//  FindMainModel.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "FindMainModel.h"

@implementation FindMainModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"findId"}];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
@end
