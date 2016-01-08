//
//  DesDetailTableViewCell.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "DesDetailTableViewCell.h"

@implementation DesDetailTableViewCell

- (void)awakeFromNib {
    self.centerImageView.layer.cornerRadius=5;
    self.centerImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
