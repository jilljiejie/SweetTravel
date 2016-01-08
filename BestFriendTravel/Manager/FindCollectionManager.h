//
//  FindCollectionManager.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindMainModel.h"
typedef void(^GetModelsBlock)(NSArray *modelArray);
typedef void(^withBlock)(BOOL isblock);
@interface FindCollectionManager : NSObject
+(FindCollectionManager *)sharedFindCollectionManager;
//向数据库插入一条数据
-(void)insertIntoModel:(FindMainModel *)model;
//获得所有的model
-(void)getAllModelsBlock:(GetModelsBlock)complicationBlock;
//删除某条数据
-(void)deleteModelwithProductId:(NSString *)product_id;
-(void)isExistModelWith:(NSString *)product_id withBlock:(withBlock)comBlock;
@end
