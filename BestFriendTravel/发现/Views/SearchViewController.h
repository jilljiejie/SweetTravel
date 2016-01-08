//
//  SearchViewController.h
//  BestFriendTravel
//
//  Created by qianfeng on 15/11/27.
//  Copyright (c) 2015年 wj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
//声明block
@property(nonatomic,copy)void(^backStringBlock)(NSString *);
@end
