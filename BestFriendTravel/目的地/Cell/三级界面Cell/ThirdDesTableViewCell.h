//
//  ThirdDesTableViewCell.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThirdDestinationModel;
@interface ThirdDesTableViewCell : UITableViewCell

@property(nonatomic,strong)ThirdDestinationModel *model;
@property(nonatomic,assign)CGFloat maxY;

@end
