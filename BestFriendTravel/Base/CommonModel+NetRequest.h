//
//  CommonModel+NetRequest.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "CommonModel.h"
typedef void(^ComplectionBlock)(NSMutableArray *array,NSError *error);
@interface CommonModel (NetRequest)
+(void)requestDataWithSn:(NSInteger)Sn withURL:(NSString *)url complectionBlock:(ComplectionBlock)comBlock;
+(void)requestDataWithURL:(NSString *)url complectionBlock:(ComplectionBlock)comBlock;
@end
