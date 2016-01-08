//
//  TravelWriteTableViewCell.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "TravelWriteTableViewCell.h"

@implementation TravelWriteTableViewCell

- (void)awakeFromNib {
    self.littleImageView.layer.cornerRadius=25;
    self.littleImageView.layer.masksToBounds=YES;
    self.littleImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.littleImageView.layer.borderWidth=1;
    self.bigImageView.layer.cornerRadius=5;
    self.bigImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
