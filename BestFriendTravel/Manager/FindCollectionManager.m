//
//  FindCollectionManager.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "FindCollectionManager.h"
#import "FMDB.h"
#import "FindMainModel.h"
@interface FindCollectionManager()
{
    FMDatabaseQueue *_dataBaseQueue;
}
@end
@implementation FindCollectionManager
+(FindCollectionManager *)sharedFindCollectionManager{
    //法1：
//    static FindCollectionManager *manager=nil;
//    if (!manager) {
//        manager=[[FindCollectionManager alloc]init];
//    }
//    return manager;
    //法2：只会调用一次，保证线程安全
    static FindCollectionManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[FindCollectionManager alloc]init];
    });
    return manager;
}
-(id)init{
    if (self=[super init]) {
        [self createDb];
    }
    return self;
}
-(void)createDb{
    
    NSString *docPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbPath=[docPath stringByAppendingPathComponent:@"like.db"];
   //法2：
//    NSString *dbPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/like.db"];
    
    NSLog(@"%@",dbPath);
    // databaseQueueWithPath 根据地址，如果有数据库就打开，如果没有数据库就创建
    _dataBaseQueue=[FMDatabaseQueue databaseQueueWithPath:dbPath];
    [self creatTableOne];
}
-(void)creatTableOne{
    ////integer 数字  varchar字符串 glob 二进制数据NSData
//    NSString *sql=@"create table if not exists LikeTable(title varchar(1024),title_page varchar(1024),avatar_l varchar(1024),date_str varchar(1024),address varchar(1024),like_conut varchar(1024),price varchar(1024),name varchar(1024),tab_list varchar(1024),findId varchar(1024),product_id varchar(1024))";
    NSString *sql=@"create table if not exists LikeTable(title text,title_page text,avatar_l text,date_str text,address text,like_conut text,price text,name text,tab_list text,findId text,product_id text)";
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        BOOL isSu=[db executeUpdate:sql];
        if (isSu) {
            NSLog(@"创建表格成功");
        }
        else{
            NSLog(@"创建表格失败");
        }
    }];
}
//向数据库插入一条数据
-(void)insertIntoModel:(FindMainModel *)model{

    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        //先判断这条数据是否存在
        NSString *selectSql=@"select *from LikeTable where product_id=?";
        FMResultSet *rs=[db executeQuery:selectSql,model.product_id];
        BOOL isE;
        isE=NO;
        while ([rs next]) {
            isE=YES;
        }
        if (isE==NO) {
            NSString *insert=@"insert into LikeTable(title,title_page,avatar_l,date_str,address,like_conut,price,name,tab_list,findId,product_id)values(?,?,?,?,?,?,?,?,?,?,?)";
            BOOL isSu=[db executeUpdate:insert,model.title,model.title_page,model.avatar_l,model.date_str,model.address,model.like_conut,model.price,model.name,model.tab_list,model.findId,model.product_id];
            if (isSu==YES) {
                NSLog(@"插入数据成功");
            }
            else{
                NSLog(@"插入数据失败");
            }
        }
    }];
}
//获得所有的model
-(void)getAllModelsBlock:(GetModelsBlock)complicationBlock{

    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *select=@"select * from LikeTable";
        FMResultSet *rs=[db executeQuery:select];
        NSMutableArray *modelArray=[[NSMutableArray alloc]init];
        while ([rs next]) {
            FindMainModel *model=[[FindMainModel alloc]init];
            model.title=[rs stringForColumn:@"title"];
            model.title_page=[rs stringForColumn:@"title_page"];
            model.avatar_l=[rs stringForColumn:@"avatar_l"];
            model.date_str=[rs stringForColumn:@"date_str"];
            model.address=[rs stringForColumn:@"address"];
            model.like_conut=[rs stringForColumn:@"like_conut"];
            model.price=[rs stringForColumn:@"price"];
            model.name=[rs stringForColumn:@"name"];
            model.tab_list=[rs stringForColumn:@"tab_list"];
            model.findId=[rs stringForColumn:@"findId"];
            model.product_id=[rs stringForColumn:@"product_id"];
            [modelArray addObject:model];
        }
        //获得所有数据之后把数组传回去
        complicationBlock(modelArray);
    }];
}
//删除某条数据
-(void)deleteModelwithProductId:(NSString *)product_id{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *delete=@"delete from LikeTable where product_id=?";
        BOOL isSu=[db executeUpdate:delete,product_id];
        if (isSu) {
            NSLog(@"数据删除成功");
        }
        else{
            NSLog(@"数据删除失败");
        }
    }];
}
-(void)isExistModelWith:(NSString *)product_id withBlock:(withBlock)comBlock{
    
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *selectSql=@"select *from LikeTable where product_id=?";
        FMResultSet *rs=[db executeQuery:selectSql,product_id];
        if ([rs next]) {
            //存在
            comBlock(YES);
        }
        else{
            comBlock(NO);
        }
        
    }];
}
@end
