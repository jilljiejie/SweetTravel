//
//  FindAllTableViewCell.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/27.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "FindAllTableViewCell.h"

@implementation FindAllTableViewCell

- (void)awakeFromNib {
    self.littleImageView.layer.cornerRadius=30;
    self.littleImageView.layer.masksToBounds=YES;
    self.littleImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.littleImageView.layer.borderWidth=2;
    self.tab_listLabel.layer.borderWidth=1;
    self.tab_listLabel.layer.borderColor=[UIColor grayColor].CGColor;
    self.tab_listLabel.layer.cornerRadius=5;
    self.tab_listLabel.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
