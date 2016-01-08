//
//  FindAllTableViewCell.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/27.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindAllTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *littleImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAddressLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tab_listLabel;

@end
