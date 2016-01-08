//
//  ThirdTwoDesTableViewCell.m
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "ThirdTwoDesTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
@interface ThirdTwoDesTableViewCell()
@property(nonatomic,strong)UILabel *labelName;//昵称
@property(nonatomic,strong)UIImageView *avatarImageView;//头像
@property(nonatomic,strong)UILabel *labelContent;//讨论的文字
@property(nonatomic,strong)UILabel *labelTrailTitle;//昵称下地文字
@property(nonatomic,strong)UIButton *likeButton;//点赞
@property(nonatomic,assign)NSInteger number;
@end
@implementation ThirdTwoDesTableViewCell
-(void)setModel:(ThirdTwoDesModel *)model{
    _model=model;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.labelName.text=model.nickname;
    self.labelTrailTitle.text=[NSString stringWithFormat:@"%@%@",model.trail_title,@"--讨论区"];
    self.labelContent.text=model.content;
    [self.likeButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    CGSize size=[model.content sizeWithFont:self.labelContent.font constrainedToSize:CGSizeMake(CGRectGetWidth(self.labelContent.frame), FLT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    CGRect frame=self.labelContent.frame;
    frame.size=size;
    self.labelContent.frame=frame;
    self.maxY=CGRectGetMaxY(frame);

}
-(UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
        _avatarImageView.layer.cornerRadius=25;
        _avatarImageView.layer.masksToBounds=YES;
        [self.contentView addSubview:_avatarImageView];
    }
    return _avatarImageView;
}
-(UILabel *)labelName{
    if (!_labelName) {
        _labelName=[[UILabel alloc]initWithFrame:CGRectMake(15+CGRectGetMaxX(self.avatarImageView.frame), 15, 100, 25)];
        _labelName.font=[UIFont systemFontOfSize:15];
        _labelName.textColor=[UIColor colorWithRed:154/255.f green:229/255.f blue:255/255.f alpha:1];
        [self.contentView addSubview:_labelName];
    }
    return _labelName;
}
-(UILabel *)labelTrailTitle{
    if (!_labelTrailTitle) {
        _labelTrailTitle=[[UILabel alloc]initWithFrame:CGRectMake(15+CGRectGetMaxX(self.avatarImageView.frame), CGRectGetMaxY(self.labelName.frame), 200, 25)];
        _labelTrailTitle.font=[UIFont systemFontOfSize:15];
        _labelTrailTitle.textColor=[UIColor grayColor];
        [self.contentView addSubview:_labelTrailTitle];
    }
    return _labelTrailTitle;
}
-(UILabel *)labelContent{
    if (!_labelContent) {
        _labelContent=[[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.avatarImageView.frame)+5, SCREEN_W-30, 50)];
        _labelContent.font=[UIFont systemFontOfSize:15];
        _labelContent.numberOfLines=0;
        _labelContent.textColor=[UIColor grayColor];
        [self.contentView addSubview:_labelContent];
    }
    return _labelContent;
}
-(UIButton *)likeButton{
    if (!_likeButton) {
        _likeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _likeButton.frame=CGRectMake(SCREEN_W-15-50, 15, 40, 40);
        [_likeButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_likeButton];
    }
    return _likeButton;
}
-(void)buttonAction{

}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
