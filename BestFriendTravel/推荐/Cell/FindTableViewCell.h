//
//  FindTableViewCell.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/26.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonModel.h"
@interface FindTableViewCell : UITableViewCell
@property(nonatomic,strong)CommonModel *model;
@property(nonatomic,strong)void(^sendUrl)(NSString *);
@end
