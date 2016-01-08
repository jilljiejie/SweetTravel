//
//  UserManager.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "UserManager.h"
#import "FMDB.h"
#import "UserModel.h"
@interface UserManager()
{
    FMDatabaseQueue *_dataBaseQueue;
}
@end
@implementation UserManager
+(UserManager *)shareUserManager{
    static UserManager *manager=nil;
    if (!manager) {
        manager=[[UserManager alloc]init];
    }
    return manager;
}
-(id)init{
    if (self=[super init]) {
        [self creatDb];
    }
    return self;
}
-(void)creatDb{
    NSString *docPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbPath=[docPath stringByAppendingPathComponent:@"user.db"];
    NSLog(@"%@",dbPath);
    _dataBaseQueue=[FMDatabaseQueue databaseQueueWithPath:dbPath];
    [self creatTable];
}
-(void)creatTable{
    NSString *sql=@"create table if not exists userMessage(userName text,passWord text)";
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        BOOL isSu=[db executeUpdate:sql];
        if (isSu==YES) {
            NSLog(@"创建表格成功");
        }
        else{
            NSLog(@"创建表格失败");
        }
    }];
}
-(void)insetIntoModel:(UserModel *)model{
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *sql=@"select * from userMessage where userName=?";
        FMResultSet *rs=[db executeQuery:sql,model.userName];
        BOOL isE;
        isE=NO;
        while ([rs next]) {
            isE=YES;
        }
        if (isE==NO) {
            NSString *insert=@"insert into userMessage(userName,passWord)values(?,?)";
            BOOL isSu=[db executeUpdate:insert,model.userName,model.passWord];
            if (isSu==YES) {
                NSLog(@"数据插入成功");
            }
            else{
                NSLog(@"数据插入失败");
            }
        }
        else{
            NSLog(@"已经存在了");
        }
    }];
}
-(NSArray *)getAllModel{
    NSMutableArray *marr=[[NSMutableArray alloc]init];
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *select=@"select * from userMessage";
        FMResultSet *rs=[db executeQuery:select];
        while ([rs next]) {
            UserModel *model=[[UserModel alloc]init];
            model.userName=[rs stringForColumn:@"userName"];
            model.passWord=[rs stringForColumn:@"passWord"];
            [marr addObject:model];
        }
    }];
    return marr;
}

@end
