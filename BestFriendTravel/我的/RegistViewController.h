//
//  RegistViewController.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/29.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import "BaseViewController.h"

@interface RegistViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *rigistButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end
