//
//  FindDetailViewController.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/12/1.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "BaseViewController.h"
#import "FindMainModel.h"
@interface FindDetailViewController : BaseViewController
@property(nonatomic,copy)NSString *productId;
@property(nonatomic,strong)FindMainModel *model;
@end
