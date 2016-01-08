//
//  CommonModel+NetRequest.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "CommonModel+NetRequest.h"
#import "AFNetworking.h"
#import "Common.h"
@implementation CommonModel (NetRequest)
//请求数据
+(void)requestDataWithSn:(NSInteger)Sn withURL:(NSString *)url complectionBlock:(ComplectionBlock)comBlock{
    //拼路径
    NSString *path=[NSString stringWithFormat:url,Sn];
    //路径中含有中文，进行转义
    NSString *utfPath=[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"😊😊😊😊%@",path);
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:utfPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError==nil) {
            NSArray *dataArr=dic[@"data"];
            NSMutableArray *modelArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dict in dataArr) {
                NSArray *subArr=dict[@"articles"];
                for (NSDictionary *lastDic in subArr) {
                    CommonModel *model=[[CommonModel alloc]initWithDictionary:lastDic error:nil];
                    [modelArray addObject:model];
//                    NSLog(@"*********%@",model);
                }
            }
            //数据解析后的回调
            comBlock(modelArray,nil);
        }
        else{
            comBlock(nil,jsonError);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        comBlock(nil,error);
    }];
}
+(void)requestDataWithURL:(NSString *)url complectionBlock:(ComplectionBlock)comBlock{
     NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:encodedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *jsonError;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError==nil) {
            NSArray *dataArr=dic[@"data"];
            NSMutableArray *modelArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dict in dataArr) {
                NSArray *subArr=dict[@"articles"];
                for (NSDictionary *lastDic in subArr) {
                    CommonModel *model=[[CommonModel alloc]initWithDictionary:lastDic error:nil];
                    [modelArray addObject:model];
                    NSLog(@"*********%@",model);
                }
            }
            //数据解析后的回调
            comBlock(modelArray,nil);
        }
        else{
            comBlock(nil,jsonError);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        comBlock(nil,error);
    }];

}
@end
