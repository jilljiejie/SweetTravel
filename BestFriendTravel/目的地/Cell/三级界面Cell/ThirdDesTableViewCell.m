//
//  ThirdDesTableViewCell.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/28.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ThirdDesTableViewCell.h"
#import "ThirdDestinationModel.h"
#import "Common.h"
@interface ThirdDesTableViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *destinationLabel;
@property (strong, nonatomic) UILabel *descripleLabel;
@end
@implementation ThirdDesTableViewCell

- (void)awakeFromNib {
    
}
-(void)setModel:(ThirdDestinationModel *)model{
    _model=model;
    self.titleLabel.text=model.name;
    self.destinationLabel.text=model.destination;
    self.descripleLabel.text=model.detail;
    CGSize size=[model.detail sizeWithFont:self.descripleLabel.font constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-40, FLT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect frame=self.descripleLabel.frame;
    frame.size=size;
    self.descripleLabel.frame=frame;
    self.maxY=CGRectGetMaxY(frame);
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10,SCREEN_W-80 , 30)];
        _titleLabel.font=[UIFont systemFontOfSize:20];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
-(UILabel *)destinationLabel{
    if (!_destinationLabel) {
        _destinationLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame), SCREEN_W-80, 30)];
        _destinationLabel.font=[UIFont systemFontOfSize:15];
        _destinationLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_destinationLabel];
    }
    return _destinationLabel;
}
-(UILabel *)descripleLabel{
    if (!_descripleLabel) {
        float width=[UIScreen mainScreen].bounds.size.width;
        _descripleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.destinationLabel.frame)+5,width , 50)];
        _descripleLabel.font=[UIFont systemFontOfSize:16];
        _descripleLabel.numberOfLines=0;
        _descripleLabel.textColor=[UIColor grayColor];
        [self.contentView addSubview:_descripleLabel];
    }
    return _descripleLabel;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
